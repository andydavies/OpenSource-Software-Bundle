# -*- encoding: utf-8 -*-
# stub: xamarin-test-cloud 0.9.29 ruby lib

Gem::Specification.new do |s|
  s.name = "xamarin-test-cloud"
  s.version = "0.9.29"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Karl Krukow", "Jonas Maturana Larsen"]
  s.date = "2014-02-06"
  s.description = "Xamarin Test Cloud lets you automatically test your app on hundreds of mobile devices"
  s.email = ["karl@xamarin.com", "jonas@xamarin.com"]
  s.executables = ["test-cloud"]
  s.files = ["bin/test-cloud"]
  s.homepage = "http://xamarin.com/test-cloud"
  s.rubygems_version = "2.2.2"
  s.summary = "Command-line interface to Xamarin Test Cloud"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, [">= 0.18.1"])
      s.add_runtime_dependency(%q<bundler>, ["< 2.0", ">= 1.3.0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<rubyzip>, ["~> 0.9.9"])
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.7"])
      s.add_runtime_dependency(%q<mime-types>, ["< 2.0"])
      s.add_runtime_dependency(%q<retriable>, ["~> 1.3.3.1"])
    else
      s.add_dependency(%q<thor>, [">= 0.18.1"])
      s.add_dependency(%q<bundler>, ["< 2.0", ">= 1.3.0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rubyzip>, ["~> 0.9.9"])
      s.add_dependency(%q<rest-client>, ["~> 1.6.7"])
      s.add_dependency(%q<mime-types>, ["< 2.0"])
      s.add_dependency(%q<retriable>, ["~> 1.3.3.1"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0.18.1"])
    s.add_dependency(%q<bundler>, ["< 2.0", ">= 1.3.0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rubyzip>, ["~> 0.9.9"])
    s.add_dependency(%q<rest-client>, ["~> 1.6.7"])
    s.add_dependency(%q<mime-types>, ["< 2.0"])
    s.add_dependency(%q<retriable>, ["~> 1.3.3.1"])
  end
end
