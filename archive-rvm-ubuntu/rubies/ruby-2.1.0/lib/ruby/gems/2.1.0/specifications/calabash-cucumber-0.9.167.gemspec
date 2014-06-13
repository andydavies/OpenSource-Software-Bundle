# -*- encoding: utf-8 -*-
# stub: calabash-cucumber 0.9.167 ruby lib

Gem::Specification.new do |s|
  s.name = "calabash-cucumber"
  s.version = "0.9.167"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Karl Krukow"]
  s.date = "2014-02-14"
  s.description = "calabash-cucumber drives tests for native iOS apps. You must link your app with calabash-ios-server framework to execute tests."
  s.email = ["karl@lesspainful.com"]
  s.executables = ["calabash-ios"]
  s.files = ["bin/calabash-ios"]
  s.homepage = "http://calaba.sh"
  s.rubygems_version = "2.2.2"
  s.summary = "Client for calabash-ios-server for automated functional testing on iOS"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, ["~> 1.3.0"])
      s.add_runtime_dependency(%q<calabash-common>, ["~> 0.0.1"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<edn>, [">= 0"])
      s.add_runtime_dependency(%q<CFPropertyList>, [">= 0"])
      s.add_runtime_dependency(%q<sim_launcher>, ["= 0.4.6"])
      s.add_runtime_dependency(%q<slowhandcuke>, [">= 0"])
      s.add_runtime_dependency(%q<geocoder>, ["~> 1.1.8"])
      s.add_runtime_dependency(%q<httpclient>, ["~> 2.3.3"])
      s.add_runtime_dependency(%q<bundler>, ["~> 1.1"])
      s.add_runtime_dependency(%q<run_loop>, ["~> 0.1.4"])
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      s.add_runtime_dependency(%q<xamarin-test-cloud>, ["~> 0.9.27"])
    else
      s.add_dependency(%q<cucumber>, ["~> 1.3.0"])
      s.add_dependency(%q<calabash-common>, ["~> 0.0.1"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<edn>, [">= 0"])
      s.add_dependency(%q<CFPropertyList>, [">= 0"])
      s.add_dependency(%q<sim_launcher>, ["= 0.4.6"])
      s.add_dependency(%q<slowhandcuke>, [">= 0"])
      s.add_dependency(%q<geocoder>, ["~> 1.1.8"])
      s.add_dependency(%q<httpclient>, ["~> 2.3.3"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<run_loop>, ["~> 0.1.4"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<xamarin-test-cloud>, ["~> 0.9.27"])
    end
  else
    s.add_dependency(%q<cucumber>, ["~> 1.3.0"])
    s.add_dependency(%q<calabash-common>, ["~> 0.0.1"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<edn>, [">= 0"])
    s.add_dependency(%q<CFPropertyList>, [">= 0"])
    s.add_dependency(%q<sim_launcher>, ["= 0.4.6"])
    s.add_dependency(%q<slowhandcuke>, [">= 0"])
    s.add_dependency(%q<geocoder>, ["~> 1.1.8"])
    s.add_dependency(%q<httpclient>, ["~> 2.3.3"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<run_loop>, ["~> 0.1.4"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<xamarin-test-cloud>, ["~> 0.9.27"])
  end
end
