# -*- encoding: utf-8 -*-
# stub: rufus-mnemo 1.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rufus-mnemo".freeze
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Mettraux".freeze]
  s.date = "2012-06-16"
  s.description = "\nTurning (large) integers into japanese sounding words and vice versa\n  ".freeze
  s.email = ["jmettraux@gmail.com".freeze]
  s.homepage = "http://github.com/jmettraux/rufus-mnemo/".freeze
  s.rubyforge_project = "rufus".freeze
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Turning (large) integers into japanese sounding words and vice versa".freeze

  s.installed_by_version = "2.6.10" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
