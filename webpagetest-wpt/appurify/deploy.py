#!/usr/bin/env python

import argparse
import paramiko
import logging
import ConfigParser
import StringIO
from contextlib import contextmanager

class DevicePropException(Exception):
    pass

class DeviceDiscoveryException(Exception):
    pass

class LocationsIniWriteException(Exception):
    pass

class SupervisorConfWriteException(Exception):
    pass

class WPT(object):
    
    repo_url = 'git@github.com:appurify/webpagetest.git'
    
    def __init__(self, kwargs):
        self.server_ip = kwargs.server_ip
        self.worker_ips = kwargs.worker_ip
        self.ssh_user = kwargs.ssh_user
        self.clients = dict()
        self.devices = dict()
    
    def setup(self):
        with self.ssh_clients():
            self.update_repo()
            self.discover_devices()
            self.generate_locations_ini()
            self.generate_supervisor_conf()
    
    def update_repo(self):
        for ip in self.clients:
            client = self.clients[ip]
            home = self.get_home_dir(client)
            stdin, stdout, stderr = client.exec_command('if [ -d "%s/wpt" ]; then cd ~/wpt && git pull origin appurify; else git clone %s wpt; fi' % (home, self.repo_url))
            err = stderr.read()
            print('[ %s ] updated repo' % ip)
    
    def generate_locations_ini(self):
        config = ConfigParser.RawConfigParser()
        locations = 'locations'
        appurify = 'Appurify'
        
        config.add_section(locations)
        config.set(locations, '1', appurify)
        
        i = 0
        config.add_section(appurify)
        for _worker_ip, _device_udid, device_prop in self.for_every_device():
            i += 1
            config.set(appurify, str(i), self.gen_unique_device_id(device_prop))
        config.set(appurify, 'label', appurify)
        
        for _worker_ip, _device_udid, device_prop in self.for_every_device():
            unique_id = self.gen_unique_device_id(device_prop)
            unique_name = self.gen_unique_device_name(device_prop)
            
            config.add_section(unique_id)
            config.set(unique_id, 'browser', unique_name)
            config.set(unique_id, 'label', 'ignored?')
            config.set(unique_id, 'type', 'nodejs,mobile')
            config.set(unique_id, 'connectivity', 'Native')
        
        output = StringIO.StringIO()
        config.write(output)
        locations_ini = output.getvalue()
        output.close()
        
        client = self.clients[self.server_ip]
        stdin, stdout, stderr = client.exec_command('echo "%s" > ~/wpt/appurify/locations.ini' % locations_ini)
        err = stderr.read()
        if err is not '':
            raise LocationsIniWriteException(err)
        print('[ %s ] saved locations.ini' % self.server_ip)
    
    def for_every_device(self):
        for worker_ip in self.devices:
            for device_udid, device_prop in self.for_every_worker_device(worker_ip):
                yield worker_ip, device_udid, device_prop
    
    def for_every_worker_device(self, ip):
        worker_devices = self.devices[ip]
        for device_udid in worker_devices:
            yield device_udid, worker_devices[device_udid]
    
    def get_home_dir(self, client):
        stdin, stdout, stderr = client.exec_command('echo $HOME')
        home = stdout.read().strip()
        return home
    
    def generate_supervisor_conf(self):
        for worker_ip in self.worker_ips:
            client = self.clients[worker_ip]
            home = self.get_home_dir(client)
            
            config = ConfigParser.RawConfigParser()
            for device_udid, device_prop in self.for_every_worker_device(worker_ip):
                unique_id = self.gen_unique_device_id(device_prop)
                name = 'program:%s' % unique_id
                config.add_section(name)
                config.set(name, 'directory', '%s/wpt/agent/js' % home)
                config.set(name, 'command', '%s/wpt/agent/js/wptdriver.sh -m debug --browser android:%s --chromePackage com.android.chrome --serverUrl %s --location %s' % (home, device_udid, self.server_ip, unique_id))
                config.set(name, 'numprocs', '1')
                config.set(name, 'stdout_logfile', '/var/log/supervisor/%s.log' % unique_id)
                config.set(name, 'redirect_stderr', 'true')
                config.set(name, 'autorestart', 'true')
                config.set(name, 'startsecs', '10')
                config.set(name, 'stopwaitsecs', '10')
                config.set(name, 'killasgroup', 'true')
            
            output = StringIO.StringIO()
            config.write(output)
            supervisor_conf = output.getvalue()
            output.close()
            
            stdin, stdout, stderr = client.exec_command('echo "%s" > ~/wpt/appurify/supervisor.conf' % supervisor_conf)
            err = stderr.read()
            if err is not '':
                raise SupervisorConfWriteException(err)
            print('[ %s ] saved supervisor.conf' % worker_ip)
    
    @contextmanager
    def ssh_clients(self):
        self.init_ssh_clients()
        yield
        self.close_ssh_clients()
    
    def _get_user_host(self, ip):
        t = ip.split('@')
        
        if len(t) == 1:
            user = self.ssh_user
            host = t[0]
        else:
            user = t[0]
            host = t[1]
        
        return user, host
    
    def init_ssh_clients(self):
        user, host = self._get_user_host(self.server_ip)
        self.clients[self.server_ip] = self.new_ssh_client(user, host)
        for worker_ip in self.worker_ips:
            if worker_ip not in self.clients:
                user, host = self._get_user_host(worker_ip)
                self.clients[worker_ip] = self.new_ssh_client(user, host)
    
    def new_ssh_client(self, user, host, port=22):
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(host, port=port, username=user)
        print('[ %s ] ssh client opened' % host)
        return client
    
    def close_ssh_clients(self):
        for ip in self.clients:
            self.clients[ip].close()
    
    def filter(self, v):
        return v.replace(' ', '-').replace('-', '_').replace('.', '')
    
    def gen_unique_device_id(self, prop):
        return '%s_%s_Android_%s' % (self.filter(prop['ro.product.brand'].title()), self.filter(prop['ro.product.model']), self.filter(prop['ro.build.version.release']))
    
    def gen_unique_device_name(self, prop):
        return "%s %s - Android %s - Chrome" % (prop['ro.product.brand'].title(), prop['ro.product.model'], prop['ro.build.version.release'])
    
    def get_device_prop(self, client, udid):
        prop = dict()
        stdin, stdout, stderr = client.exec_command("source ~/.profile && adb -s %s shell getprop" % udid)
        
        err = stderr.read()
        if err is not '':
            raise DevicePropException('worker ssh client %r returned error %s during udid getprop' % (client, err))
        
        properties = stdout.read().strip().split('\n')
        for line in properties:
            parts = line.split(':')
            if len(parts) is not 2:
                continue
            
            key = parts[0].strip()[1:][:-1]
            value = parts[1].strip()[1:][:-1]
            prop[key] = value
        
        return prop
    
    def discover_devices(self):
        for worker_ip in self.worker_ips:
            self.devices[worker_ip] = dict()
            
            client = self.clients[worker_ip]
            stdin, stdout, stderr = client.exec_command("source ~/.profile && adb devices | awk '{ print $1 }' | grep -v List | grep -v '^$'")
            
            err = stderr.read()
            if err is not '':
                raise DeviceDiscoveryException('worker ssh client %s returned error %s during udid discovery' % (worker_ip, err))
            
            udids = stdout.read().strip().split('\n')
            for udid in udids:
                self.devices[worker_ip][udid] = self.get_device_prop(client, udid)
                print('[ %s ] discovered device %s' % (worker_ip, udid))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--server-ip', help='server ip address')
    parser.add_argument('--worker-ip', action='append', help='worker ip addresses')
    parser.add_argument('--ssh-user', default='appurifyadmin', help='user to ssh with')
    wpt = WPT(parser.parse_args())
    wpt.setup()
