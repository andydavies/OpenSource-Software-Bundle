require 'thor'
require 'yaml'
require 'erb'
require 'rubygems'
require 'zip/zip'
require 'digest'
require 'rest_client'
require 'json'
require 'rbconfig'
require 'tmpdir'
require 'fileutils'
require 'retriable'
require 'xamarin-test-cloud/version'


module XamarinTestCloud

  class ValidationError < Thor::InvocationError
  end

  class CLI < Thor
    include Thor::Actions

    attr_accessor :host, :app, :api_key, :appname, :app_explorer, :test_parameters,
                  :workspace, :config, :profile, :skip_config_check
    attr_accessor :dry_run, :device_selection
    attr_accessor :pretty, :async
    attr_accessor :endpoint_path

    FILE_UPLOAD_ENDPOINT = 'upload2'
    FORM_URL_ENCODED_ENDPOINT = 'upload'


    def self.source_root
      File.join(File.dirname(__FILE__), '..')
    end

    desc 'version', 'Prints version of the xamarin-test-cloud gem'

    def version
      puts XamarinTestCloud::VERSION
    end

    desc 'submit <APP> <API_KEY>', 'Submits your app and test suite to Xamarin Test Cloud'


    method_option :host,
                  :desc => 'Test Cloud host to submit to',
                  :aliases => '-h', :type => :string,
                  :default => (ENV['XTC_ENDPOINT'] || 'https://testcloud.xamarin.com/ci')

    method_option 'app-name',
                  :desc => 'App name to create or add test to',
                  :aliases => '-a',
                  :required => false,
                  :type => :string

    method_option 'device-selection',
                  :desc => 'Device selection',
                  :aliases => '-d',
                  :required => true,
                  :type => :string

    method_option 'app-explorer',
                  :desc => 'Explore using AppExplorer only (no Calabash)',
                  :aliases => '-e',
                  :type => :boolean,
                  :default => false

    method_option 'test-parameters',
                  :desc => 'Test parameters (e.g., -params username:nat@xamarin.com password:xamarin)',
                  :aliases => '-params',
                  :type => :hash

    method_option :workspace,
                  :desc => 'Path to your Calabash workspace (containing your features folder)',
                  :aliases => '-w',
                  :type => :string

    method_option :config,
                  :desc => 'Cucumber configuration file (cucumber.yml)',
                  :aliases => '-c',
                  :type => :string

    method_option 'skip-config-check',
                  :desc => "Force running without Cucumber profile (cucumber.yml)",
                  :type => :boolean,
                  :default => false

    method_option :profile,
                  :desc => 'Profile to run (profile from cucumber.yml)',
                  :aliases => '-p',
                  :type => :string

    method_option :pretty,
                  :desc => 'Pretty print output.',
                  :type => :boolean,
                  :default => false

    method_option :async,
                  :desc => "Don't block waiting for test results.",
                  :type => :boolean,
                  :default => false

    method_option 'dry-run',
                  :desc => "Sanity check only, don't upload",
                  :aliases => '-s',
                  :type => :boolean,
                  :default => false #do upload by default

    def submit(app, api_key)

      self.host = options[:host]

      self.pretty = options[:pretty]

      app_path = File.expand_path(app)
      unless File.exist?(app_path)
        raise ValidationError, "App is not a file: #{app_path}"
      end

      if shared_runtime?(app_path)
        puts "Xamarin Test Cloud doesn't yet support shared runtime apps."
        puts "To test your app it needs to be compiled for release."
        puts "You can learn how to compile you app for release here:"
        puts "http://docs.xamarin.com/guides/android/deployment%2C_testing%2C_and_metrics/publishing_an_application/part_1_-_preparing_an_application_for_release"
        raise ValidationError, "Aborting"
      end

      app_extension = File.extname(app_path)
      unless /ipa/i.match(app_extension) || /apk/i.match(app_extension)
        raise ValidationError, "App #{app_path} must be an .ipa or .apk file"
      end


      self.app = app_path

      self.async = options[:async]

      self.dry_run = options['dry-run']

      self.api_key = api_key

      self.test_parameters = options['test-parameters'] || {}

      self.appname = options['app-name']

      self.device_selection = options['device-selection']

      device_selection_data = validate_device_selection

      self.app_explorer = options['app-explorer']


      self.skip_config_check = options['skip-config-check']


      workspace_path = options[:workspace] || File.expand_path('.')

      unless self.app_explorer
        unless File.directory?(workspace_path)
          raise ValidationError, "Provided workspace: #{workspace_path} is not a directory."
        end
      end



      workspace_basename = File.basename(workspace_path)
      if workspace_basename.downcase == 'features'
        self.workspace = File.expand_path(File.join(workspace_path,'..'))
        puts "Deriving workspace #{self.workspace} from features folder #{workspace_basename}"
      else
        self.workspace = File.expand_path(workspace_path)
      end

      self.workspace = File.join(self.workspace, File::Separator)


      unless self.app_explorer
        unless File.directory?(File.join(self.workspace, 'features'))
          log_header "Did not find features folder in workspace #{self.workspace}"
          puts "Either run the test-cloud command from the directory containing your features"
          puts "or use the --workspace option to refer to this directory"
          puts "See also test-cloud help submit"
          raise ValidationError, "Unable to find features folder in #{self.workspace}"
        end
      end

      unless app_explorer
        parse_and_set_config_and_profile
        unless self.skip_config_check
          default_config = File.join(self.workspace,'config','cucumber.yml')
          if File.exist?(default_config) && self.config.nil?
            log_header 'Warning: Detected cucumber.yml config file, but no --config specified'
            puts "Please specify --config #{default_config}"
            puts 'and specify a profile via --profile'
            puts 'If you know what you are doing you can skip this check with'
            puts '--skip-config-check'
            raise ValidationError, "#{default_config} detected but no profile selected."
          end
        end
      end


      if ENV['DEBUG']
        puts "Host = #{self.host}"
        puts "App = #{self.app}"
        puts "App Name = #{self.app}"
        puts "AppExplorer = #{self.app_explorer}"
        puts "TestParams = #{self.test_parameters}"
        puts "API Key = #{self.api_key}"
        puts "Device Selection = #{self.device_selection}"
        puts "Workspace = #{self.workspace}"
        puts "Config = #{self.config}"
        puts "Profile = #{self.profile}"
      end


      #Argument parsing done

      test_jon_data = submit_test_job(device_selection_data)
      if self.dry_run
        return
      end
      json = test_jon_data[:body]
      if ENV['DEBUG']=='1'
        p json
      end

      log_header('Test enqueued')
      puts "User: #{json['user_email']}"


      rejected_devices = json['rejected_devices']
      if rejected_devices && rejected_devices.size > 0
        puts 'Skipping devices (you can update your selections via https://testcloud.xamarin.com)'
        rejected_devices.each {|d| puts d}
      end
      puts ''

      puts 'Running on Devices:'
      json['devices'].each do |device|
        puts device
      end
      puts ''


      unless self.async
        wait_for_job(json['id'])
      else
        log 'Async mode: not awaiting test results'
      end

    end

    default_task :submit

    no_tasks do

      def exit_on_failure?
        true
      end

      def wait_for_job(id)
        while(true)
          status_json = retriable :tries => 60, :interval => 10 do
            JSON.parse(http_post("status", {'id' => id, 'api_key' => api_key}))
          end

          log  "Status: #{status_json["status_description"]}"
          if status_json["status"] == "finished"
            puts "Done!"
            if ENV['DEBUG'] == '1'
              log "Status JSON result"
              puts status_json
            end
            log_header "Test Summary"
            calabash_data = status_json["calabash_data"]

            if calabash_data
              failed = calabash_data["scenarios"]["failed"].to_i
              puts "Total scenarios: #{calabash_data["scenarios"]["total"]}"
              puts "#{calabash_data["scenarios"]["passed"]} passed"
              puts "#{failed} failed"
              puts "Total steps: #{calabash_data["steps"]["total"]}"

              puts ""
              puts "Test Report:"
              puts status_json['share_link']
              if failed > 0
                exit 1
              end
            end
            exit 0
          end

          if ["cancelled", "invalid"].include?(status_json["status"])
            puts "Failed!"
            if status_json['reason']
              puts "Reason: #{status_json['status']}"
              puts "Details:"
              puts status_json['reason']
            end
            exit 1
          end
          if ENV['DEBUG']=='1'
            sleep 1
          else
            sleep 10
          end
        end
      end

      def validate_device_selection
        unless /^[0-9a-fA-F]{8,12}$/ =~ device_selection
          raise ValidationError, 'Device selection is not in the proper format. Please generate a new one on the Xamarin Test Cloud website.'
        end
        device_selection
      end

      def workspace_gemfile
        File.join(self.workspace, 'Gemfile')
      end

      def workspace_gemfile_lock
        File.join(self.workspace, 'Gemfile.lock')
      end

      def submit_test_job(device_selection_data)
        tmpdir = Dir.mktmpdir
        if ENV['DEBUG']
          log "Packaging gems in: #{tmpdir}"
        end
        start_at = Time.now

        unless self.app_explorer
          server = verify_app_and_extract_test_server

          log_header('Checking for Gemfile')

          if File.exist?(workspace_gemfile)
            FileUtils.cp workspace_gemfile, tmpdir
            FileUtils.cp workspace_gemfile_lock, tmpdir if File.exist?(workspace_gemfile_lock)
          else
            copy_default_gemfile(File.join(tmpdir, "Gemfile"), server)
          end

          log_header('Packaging')

          ENV['BUNDLE_GEMFILE'] = File.join(tmpdir, "Gemfile")
          FileUtils.cd(self.workspace) do
            unless system('bundle package --all')
              log_and_abort 'Bundler failed. Please check command: bundle package'
            end
          end
          log_header('Verifying dependencies')
          verify_dependencies(tmpdir)
        end


        if dry_run
          log_header('Dry run only')
          log('Dry run completed OK')
          return
        end

        app_file, files, paths = gather_files_and_paths_to_upload(all_files(tmpdir), tmpdir)


        log_header('Uploading negotiated files')

        upload_data = {'files' => files,
                       'paths' => paths,
                       'client_version' => XamarinTestCloud::VERSION,
                       'app_file' => app_file,
                       'device_selection' => device_selection_data,
                       'app' => self.appname,
                       'test_parameters' => self.test_parameters,
                       'app_explorer' => self.app_explorer,
                       'api_key' => api_key,
                       'app_filename' => File.basename(app)}

        if profile #only if config and profile
          upload_data['profile'] = profile
        end

        if ENV['DEBUG']
          puts JSON.pretty_generate(upload_data)
        end


        contains_file = files.find { |f| f.is_a?(File) }

        contains_file = contains_file || app_file.is_a?(File)

        if contains_file
          self.endpoint_path = FILE_UPLOAD_ENDPOINT #nginx receives upload
        else
          self.endpoint_path = FORM_URL_ENCODED_ENDPOINT #ruby receives upload
        end

        if ENV['DEBUG']
          puts "Will upload to file path: #{self.endpoint_path}"
        end


        response = http_post(endpoint_path, upload_data) do |response, request, result, &block|
          if ENV['DEBUG']
            puts "Request url: #{request.url}"
            puts "Response code: #{response.code}"
            puts "Response body: #{response.body}"
          end
          case response.code
            when 200..202
              response
            when 400
              abort do
                puts 'Bad request'
                puts response.body
              end
            when 403
              abort do
                puts 'Invalid API key'
              end
            when 413
              abort do
                puts 'Files too large'
              end
            else
              begin
                r = JSON.parse(response)
                if r["invalid_platform"]
                  abort do
                    if r["invalid_platform"] == "android"
                      log "#{app} cannot be tested on Android devices. Please create a new device selection on the Xamarin Test Cloud website."
                    else
                      log "#{app} cannot be tested on iOS devices. Please create a new device selection on the Xamarin Test Cloud website."
                    end
                  end
                end
              rescue
              end
              abort do
                log 'Unexpected Error. Please contact support at testcloud@xamarin.com.'
              end
          end
        end

        return :status => response.code, :body => JSON.parse(response)
        
      end


      def copy_default_gemfile(gemfile_path, server)
        log('')
        log('Gemfile missing.')
        log('You must provide a Gemfile in your workspace.')
        log('A Gemfile must describe your dependencies and their versions')
        log('See: http://gembundler.com/v1.3/gemfile.html')
        log('')
        log('Warning proceeding with default Gemfile.')
        log('It is strongly recommended that you create a custom Gemfile.')
        
        File.open(gemfile_path, "w") do |f|
          f.puts "source 'http://rubygems.org'"
          if is_android?
            f.puts "gem 'calabash-android', '#{calabash_android_version}'"
          elsif is_ios?
            f.puts "gem 'calabash-cucumber', '#{calabash_ios_version}'"
          else
            raise ValidationError, 'Your app must be an ipa or apk file.'
          end
        end
        log("Proceeding with Gemfile: #{gemfile_path}")

        puts(File.read(gemfile_path))

        log('')
      end

      def gather_files_and_paths_to_upload(collected_files, tmpdir)

        log_header('Calculating digests')

        file_paths = collected_files[:files]
        feature_prefix = collected_files[:feature_prefix]
        workspace_prefix = collected_files[:workspace_prefix]

        hashes = file_paths.collect { |f| digest(f) }

        if hashes.nil? || hashes.size == 0
          hashes << '0222222222222222222222222222222222222222222222222222222222222222'
        end


        log_header('Negotiating upload')

        response = http_post('check_hash', {'hashes' => hashes, 'app_hash' => digest(app)})

        cache_status = JSON.parse(response)

        log_header('Gathering files based on negotiation')

        files = []
        paths = []
        file_paths.each do |file|
          if cache_status[digest(file)]
            #Server already knows about this file. No need to upload it.
            files << digest(file)
          else
            #Upload file
            files << File.new(file)
          end

          if file.start_with?(feature_prefix)
            prefix = feature_prefix
          else
            prefix = workspace_prefix
          end
          paths << file.sub(prefix, '').sub("#{tmpdir}/", '')
        end

        if config
          files << File.new(config)
          paths << 'config/cucumber.yml'
        end

        app_file = cache_status[digest(app)] ? digest(app) : File.new(app)

        return app_file, files, paths
      end

      def digest(file)
        Digest::SHA256.file(file).hexdigest
      end

      def unzip_file (file, destination)
        Zip::ZipFile.open(file) { |zip_file|
          zip_file.each { |f|
            f_path=File.join(destination, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          }
        }
      end


      def is_android?
        app.end_with? '.apk'
      end

      def is_ios?
        app.end_with? '.ipa'
      end

      def calabash_android_version
        version = nil


        if File.exist?(workspace_gemfile)
          FileUtils.cd(self.workspace) do
            version = `bundle exec ruby -e "require 'calabash-android/version'; puts Calabash::Android::VERSION"`
            version = version && version.strip
          end
        end
        unless version
          require 'calabash-android'
          version = Calabash::Android::VERSION
        end

        version = version.strip
      end

      def calabash_ios_version
        version = nil
        if File.exist?(workspace_gemfile)
          FileUtils.cd(self.workspace) do
           version = `bundle exec ruby -e "require 'calabash-cucumber/version'; puts Calabash::Cucumber::VERSION"`
           version = version && version.strip
          end
        end
        unless version
          require 'calabash-cucumber'
          version = Calabash::Cucumber::VERSION
        end
        version = version.strip
      end

      def test_server_path
        require 'digest/md5'
        digest = Digest::MD5.file(app).hexdigest
        File.join(self.workspace, 'test_servers', "#{digest}_#{calabash_android_version}.apk")
      end

      def all_files(tmpdir)
        dir = workspace

        if self.app_explorer
          files = []
        else
          files = Dir.glob(File.join("#{dir}features", '**', '*'))

          if File.directory?("#{dir}playback")
            files += Dir.glob(File.join("#{dir}playback", '*'))
          end

          if config
            files << config
          end


          files += Dir.glob(File.join(tmpdir,"vendor", 'cache', '*'))

          if workspace and workspace.strip != ''
            files += Dir.glob("#{workspace}Gemfile")
            files += Dir.glob("#{workspace}Gemfile.lock")
          end

          if is_android?
            files << test_server_path
          end

        end

        {:feature_prefix => dir, :workspace_prefix => workspace, :files => files.find_all { |file_or_dir| File.file? file_or_dir }}
      end

      def http_post(address, args, &block)
        exec_options = {}
        if ENV['XTC_USERNAME'] && ENV['XTC_PASSWORD']
          exec_options[:user] = ENV['XTC_USERNAME']
          exec_options[:password] = ENV['XTC_PASSWORD']
        end

        if block_given?
          exec_options = exec_options.merge({:method => :post, :url => "#{host}/#{address}", :payload => args,
                          :timeout => 90000000,
                          :open_timeout => 15,
                          :headers => {:content_type => 'multipart/form-data'}})
          response = RestClient::Request.execute(exec_options) do |response, request, result, &other_block|
            block.call(response, request, result, &other_block)
          end
        else
          exec_options = exec_options.merge(:method => :post, :url => "#{host}/#{address}", :payload => args)
          response = RestClient::Request.execute(exec_options)
        end

        response.body
      end

      def is_windows?
        (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)
      end

      def is_macosx?
        (RbConfig::CONFIG['host_os'] =~ /darwin/)
      end

      def validate_ipa(ipa)
        result = false
        dir = Dir.mktmpdir #do |dir|

        unzip_file(ipa, dir)
        unless File.directory?("#{dir}/Payload") #macos only
          raise ValidationError, "Unzipping #{ipa} to #{dir} failed: Did not find a Payload directory (invalid .ipa)."
        end
        app_dir = Dir.foreach("#{dir}/Payload").find { |d| /\.app$/.match(d) }
        res = `otool "#{File.expand_path(dir)}/Payload/#{app_dir}/"* -o 2> /dev/null | grep CalabashServer`

        if /CalabashServer/.match(res)
          puts "ipa: #{ipa} *contains* calabash.framework"
          result = :calabash
        end

        unless result
          res = `otool "#{File.expand_path(dir)}/Payload/#{app_dir}/"* -o 2> /dev/null | grep FrankServer`
          if /FrankServer/.match(res)
            puts "ipa: #{ipa} *contains* FrankServer"
            raise ValidationError, 'Frank not supported just yet'
          else
            puts "ipa: #{ipa} *does not contain* calabash.framework"
            result = false
          end
        end

        result
      end


      def log(message)
        puts "#{Time.now } #{message}"
        $stdout.flush
      end

      def log_header(message)
        if is_windows?
          puts "\n### #{message} ###"
        else
          puts "\n\e[#{35}m### #{message} ###\e[0m"
        end
      end


      def verify_app_and_extract_test_server
        server = nil

        unless File.exist?(app)
          raise ValidationError, "No such file: #{app}"
        end
        unless (/\.(apk|ipa)$/ =~ app)
          raise ValidationError, '<APP> should be either an ipa or apk file.'
        end
        if is_ios? and is_macosx?
          log_header('Checking ipa for linking with Calabash')
          server = validate_ipa(app)
          abort_unless(server) do
            puts 'The .ipa file does not seem to be linked with Calabash.'
            puts 'Verify that your app is linked correctly.'
          end
        end
        server
      end

      def abort(&block)
        yield block
        exit 1
      end

      def abort_unless(condition, &block)
        unless condition
          yield block
          exit 1
        end
      end

      def log_and_abort(message)
        abort do
          puts message
        end
      end


      def shared_runtime?(app_path)
        files(app_path).any? do |file|
          file[:filename].end_with?("libmonodroid.so") && file[:size] < 120 * 1024
        end
      end

      def files(app)
        require 'zip/zipfilesystem'
        Zip::ZipFile.open(app) do |zip_file|
          zip_file.collect do |entry|
            {:filename => entry.to_s, :size => entry.size }
          end
        end
      end



      def verify_dependencies(path)
        if is_android?
          abort_unless(File.exist?(test_server_path)) do
            puts 'No test server found. Please run:'
            puts "  calabash-android build #{app}"
          end
          calabash_gem = Dir.glob("#{path}/vendor/cache/calabash-android-*").first
          abort_unless(calabash_gem) do
            puts 'calabash-android was not packaged correct.'
            puts 'Please tell testcloud@xamarin.com about this bug.'
          end
        end
      end


      def parse_and_set_config_and_profile
        config_path = options[:config]
        if config_path
          config_path = File.expand_path(config_path)
          unless File.exist?(config_path)
            raise ValidationError, "Config file does not exist #{config_path}"
          end


          begin
            config_yml = YAML.load(ERB.new(File.read(config_path)).result)
          rescue Exception => e
            puts "Unable to parse #{config_path} as yml. Is this your Cucumber.yml file?"
            raise ValidationError, e
          end

          if ENV['DEBUG']
            puts 'Parsed Cucumber config as:'
            puts config_yml.inspect
          end

          profile = options[:profile]
          unless profile
            raise ValidationError, 'Config file provided but no profile selected.'
          else
            unless config_yml[profile]
              raise ValidationError, "Config file provided did not contain profile #{profile}."
            else
              puts "Using profile #{profile}..."
              self.profile = profile
            end
          end
        else
          if options[:profile]
            raise ValidationError, 'Profile selected but no config file provided.'
          end
        end

        self.config = config_path
      end

    end


  end
end


