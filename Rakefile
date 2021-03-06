require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "restful_press"
    gem.summary = %Q{Ruby client for the Restful Press API}
    gem.description = %Q{Restful Press is an automated service for converting your app's views into PDFs. }
    gem.email = "mauricio@geminisbs.com"
    gem.homepage = "http://github.com/geminisbs/restful_press"
    gem.authors = ["Mauricio Gomes"]
    
    gem.add_dependency "yajl-ruby", "~> 0.7.7"
    gem.add_dependency "rest-client", "~> 1.6.0"
    
    gem.add_development_dependency "rspec", ">= 1.2.9"
    
    gem.files = FileList['lib/**/*.rb', 'VERSION', 'LICENSE', "README.rdoc"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "restful_press #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
