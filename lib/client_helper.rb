module ClientHelper
  def self.included(base)
    base.class_eval do
      include HTTParty
      include Rubycious::Errors

      base_uri "https://api.del.icio.us/v1"
      basic_auth base.new.username, base.new.password
      format :xml

      def initialize(auth_options = {:username => nil, :password => nil})
        @username, @password= auth_options[:username], auth_options[:password]
      end
    end
  end

  def config
    @config= YAML::load(File.read(File.join(ROOT_DIR,'config','auth.yml')))
  end
  
  def username
    if username = self.instance_variable_get('@username') || config["username"]
      instance_variable_set('@username', username)
      username
    else
      raise AuthenticationError, "Couldn't find username"
    end
  end

  def password
    if password = self.instance_variable_get('@username') || config["password"]
      instance_variable_set('@password', password)
      password
    else
      raise AuthenticationError, "Couldn't find password"
    end
  end

end

