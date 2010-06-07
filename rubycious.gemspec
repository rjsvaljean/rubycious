# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubycious}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ratan Sebastian"]
  s.date = %q{2010-05-14}
  s.description = %q{Ruby wrapper to the del.icio.us API}
  s.email = %q{rjsvaljean@gmail.com}
  s.extra_rdoc_files = ["LICENSE.rdoc", "README.rdoc", "lib/client.rb", "lib/client_helper.rb", "lib/errors.rb", "lib/rubycious.rb"]
  s.files = ["LICENSE.rdoc", "README.rdoc", "Rakefile", "config/auth.yml", "features/post_client.feature", "lib/client.rb", "lib/client_helper.rb", "lib/errors.rb", "lib/rubycious.rb", "Manifest", "rubycious.gemspec"]
  s.homepage = %q{http://github.com/rjsvlajean/rubycious}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rubycious", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rubycious}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Ruby wrapper to the del.icio.us API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<httparty>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
  end
end
