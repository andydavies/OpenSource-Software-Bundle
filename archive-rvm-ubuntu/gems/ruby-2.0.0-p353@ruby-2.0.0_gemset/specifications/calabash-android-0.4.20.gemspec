# -*- encoding: utf-8 -*-
# stub: calabash-android 0.4.20 ruby lib

Gem::Specification.new do |s|
  s.name = "calabash-android"
  s.version = "0.4.20"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jonas Maturana Larsen"]
  s.date = "2014-01-31"
  s.description = "calabash-android drives tests for native  and hybrid Android apps. "
  s.email = ["jonas@lesspainful.com"]
  s.executables = ["calabash-android"]
  s.files = ["bin/calabash-android"]
  s.homepage = "http://github.com/calabash"
  s.rubygems_version = "2.2.2"
  s.summary = "Client for calabash-android for automated functional testing on Android"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<retriable>, ["~> 1.3.3.1"])
      s.add_runtime_dependency(%q<slowhandcuke>, [">= 0"])
      s.add_runtime_dependency(%q<rubyzip>, ["~> 0.9.9"])
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      s.add_runtime_dependency(%q<httpclient>, ["~> 2.3.2"])
      s.add_runtime_dependency(%q<xamarin-test-cloud>, [">= 0.9.23"])
      s.add_runtime_dependency(%q<escape>, ["~> 0.0.4"])
    else
      s.add_dependency(%q<cucumber>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<retriable>, ["~> 1.3.3.1"])
      s.add_dependency(%q<slowhandcuke>, [">= 0"])
      s.add_dependency(%q<rubyzip>, ["~> 0.9.9"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<httpclient>, ["~> 2.3.2"])
      s.add_dependency(%q<xamarin-test-cloud>, [">= 0.9.23"])
      s.add_dependency(%q<escape>, ["~> 0.0.4"])
    end
  else
    s.add_dependency(%q<cucumber>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<retriable>, ["~> 1.3.3.1"])
    s.add_dependency(%q<slowhandcuke>, [">= 0"])
    s.add_dependency(%q<rubyzip>, ["~> 0.9.9"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<httpclient>, ["~> 2.3.2"])
    s.add_dependency(%q<xamarin-test-cloud>, [">= 0.9.23"])
    s.add_dependency(%q<escape>, ["~> 0.0.4"])
  end
end
