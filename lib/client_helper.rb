module ClientHelper
  def self.included(base)
    base.class_eval do
      include HTTParty
      include Rubycious::Errors

      base_uri "https://api.del.icio.us/v1"
      format :xml

      attr_accessor :username, :password

      def initialize(auth_options = {:username => nil, :password => nil})
        @username, @password= auth_options[:username], auth_options[:password]
        self.class.basic_auth @username, @password
      end
    end
  end


end

