require 'rubygems'
require 'rake/gempackagetask'
 
spec = Gem::Specification.new do |s|
  s.name = 'rack-restful-controller'
  s.version = '0.0.1'
  s.homepage = 'http://github.com/ryanbriones/rack-restful-controller'
  s.summary = 'Rack application, "RESTful" Rails style.'
  s.files = FileList['[A-Z]*', 'lib/rack/restful-controller.rb']
  s.has_rdoc = false
  s.author = 'Ryan Carmelo Briones'
  s.email = 'ryan.briones@brionesandco.com'

  s.add_dependency 'rack', '>=1.0.0'
end
 
package_task = Rake::GemPackageTask.new(spec) {}
 
desc "Write out #{spec.name}.gemspec"
task :build_gemspec do
  File.open("#{spec.name}.gemspec", "w") do |f|
    f.write spec.to_ruby
  end
end
 
task :default => [:build_gemspec, :gem]
