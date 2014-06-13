# -*- encoding: utf-8 -*-
# stub: sim_launcher 0.4.6 ruby lib

Gem::Specification.new do |s|
  s.name = "sim_launcher"
  s.version = "0.4.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Pete Hodgson"]
  s.date = "2012-10-01"
  s.email = ["rubygems@thepete.net"]
  s.executables = ["sim_launcher"]
  s.files = ["bin/sim_launcher"]
  s.homepage = "http://rubygems.org/gems/sim_launcher"
  s.rubygems_version = "2.2.2"
  s.summary = "tiny HTTP server to launch an app in the iOS simulator"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
  end
end
