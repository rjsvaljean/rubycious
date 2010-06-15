require 'rubygems'  
require 'rake'  
require 'echoe'  

Echoe.new('rubycious', '0.1.2') do |p|  
  p.description     = "Ruby wrapper to the del.icio.us API"  
  p.url             = "http://github.com/rjsvaljean/rubycious"  
  p.author          = "Ratan Sebastian"  
  p.email           = "rjsvaljean@gmail.com"  
  p.ignore_pattern  = ["tmp/*", "script/*"]  
  p.development_dependencies = ["httparty"]
end  

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }  
