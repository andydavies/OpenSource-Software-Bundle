# -*- encoding: utf-8 -*-
# stub: calabash-common 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "calabash-common"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Karl Krukow", "Jonas Maturana Larsen"]
  s.date = "2013-05-14"
  s.description = "Contains shared functionality and extentions to various Calabash sub-projects."
  s.email = ["karl@xamarin.com", "jonas@xamarin.com"]
  s.homepage = "http://calaba.sh"
  s.rubygems_version = "2.2.2"
  s.summary = "Tools related to running Calabash"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cucumber>, ["~> 1.3.0"])
    else
      s.add_dependency(%q<cucumber>, ["~> 1.3.0"])
    end
  else
    s.add_dependency(%q<cucumber>, ["~> 1.3.0"])
  end
end
