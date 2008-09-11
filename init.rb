Dir[File.dirname(__FILE__) + "/lib/**/*.rb"].each do |feature|
  require feature
end
