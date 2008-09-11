# Copyright (c) 2007, 2008 Pythonic Pty. Ltd. http://www.pythonic.com.au/

class << ActiveRecord::Base
  # Loads adapter-specific features from plugins after database connection is
  # established. Plugins should not themselves load adapter-specific features
  # because database client libraries may not be available.
  #
  # Plugins should implement adapter-specific features in files named as in
  # ActiveRecord (for example, lib/connection_adapters/postgresql_adapter.rb)
  # and should not load those files in init.rb:
  #   Dir[File.dirname(__FILE__) + "/lib/**/*.rb"].each do |feature|
  #     require feature if feature !~ /\/(?!abstract)[^\/]+_adapter.rb$/
  #   end
  #
  # This plugin itself is loaded after the connection is established, so the
  # application should re-establish the connection during initialization
  # in config/initializers/establish_connection.rb:
  #   ActiveRecord::Base.establish_connection
  def establish_connection_with_plugins(spec = nil)
    s = establish_connection_without_plugins(spec)
    if spec.is_a? Hash
      adapter = spec.symbolize_keys[:adapter]
      Dir["vendor/plugins/*/lib/connection_adapters/#{adapter}_adapter.rb"].each do |feature|
        require feature
      end
    end
    s
  end
  alias_method_chain :establish_connection, :plugins
end
