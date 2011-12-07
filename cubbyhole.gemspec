# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cubbyhole/version"

Gem::Specification.new do |s|
  s.name        = "cubbyhole"
  s.version     = Cubbyhole::VERSION
  s.authors     = ["Andy Delcambre"]
  s.email       = ["adelcambre@engineyard.com"]
  s.homepage    = ""
  s.summary     = %q{A zero config data store}
  s.description = %q{This project will be a zero configuation datastore that aims to be ActiveModel compliant}

  s.rubyforge_project = "cubbyhole"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "i18n"
end
