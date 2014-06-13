# -*- encoding: utf-8 -*-
# stub: run_loop 0.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "run_loop"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Karl Krukow"]
  s.date = "2014-03-03"
  s.description = "calabash-cucumber drives tests for native iOS apps. RunLoop provides a number of tools associated with running Calabash tests."
  s.email = ["karl@lesspainful.com"]
  s.executables = ["run-loop"]
  s.files = ["bin/run-loop"]
  s.homepage = "http://calaba.sh"
  s.rubygems_version = "2.2.2"
  s.summary = "Tools related to running Calabash iOS tests"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
