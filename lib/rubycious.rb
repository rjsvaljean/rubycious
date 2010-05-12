require 'httparty'

ROOT_DIR= File.join(File.dirname(__FILE__),'..')
# load File.join(ROOT_DIR, 'lib', 'errors.rb')
load File.join(ROOT_DIR, 'lib', 'client_helper.rb')
# load File.join(ROOT_DIR, 'lib', 'client.rb')

module Rubycious


  module Errors

    class DeliciousError < StandardError
    end

    class AuthenticationError < StandardError
    end

    def handle_errors
      response= yield
      if response.keys.include?("result")
        if response["result"].match("done")
          response
        else
          raise DeliciousError, response["result"]["code"]
        end
      else
        response
      end
    end
  end

  module Client
    def self.last_update
      response= self.new.handle_errors do
        get('/posts/update')
      end
      Time.parse(response["update"]["time"])
    end

    class Post
      include ClientHelper

      base_uri "#{base_uri}/posts"

      # Options
      # :url => (required) http://somelink.com/somepage
      # :description => (required) This is a really cool link that I found
      # :dt => (optional) CCYY-MM-DDThh:mm:ssZ filter by date
      # :hash => (optional) MD5+MD5+....+MD5  Fetch multiple bookmarks by one or more URL MD5s regardless of date, separated by URL-encoded spaces (ie. '+').
      # :extended => (optional) This is some further information about the link
      # :tags => (optional) space seporated list of tags
      # :replace => (optional) yes/no
      # :shared => (optional) yes/no
      def save
        handle_errors { self.class.get('/add', :query => @options) }
      end

      # Options:
      # :tag => "ruby+rails+httparty"
      # :dt => CCYY-MM-DDThh:mm:ssZ
      # :url => URL
      # :hashes => "c0238dc0c44f07daedd9a1fd9bbdeebd+2f9704c729e7ed3b41647b7d0ad649fe+..+2f9704c729e7ed3b41647b7d0ad649fe"
      # :meta => yes/no to indicate whether or not to retreive the meta hash tag
      # METHOD DEPRECATED due to uselessness
      def find_latest(options)
        response= handle_errors { self.class.get('/get', :query => options)}
        response["posts"]
      end

      # Options:
      # :tag =>(optional)  "ruby"
      # :start =>(optional)  Integer: Start returning posts this many results into the set
      # :results =>(optional)  Integer: Return these many results 
      # :fromdt =>(optional)  {Time#iso8601}: On this date or later
      # :todt =>(optional)  {Time#iso8601}: On this date or earlier
      # :meta =>(optional)  yes/no: Include change detection signatures on each item in a 'meta' attribute. Clients wishing to maintain a synchronized local store of bookmarks should retain the value of this attribute - its value will change when any significant field of the bookmark changes.
      # NOTE: Use Sparingly. Call the update function to see if you need to fetch this at all.
      def find(options)
        response= handle_errors { self.class.get('/all', :query => options)}
        response["posts"]["post"].collect{|i| Rubycious::Post.new(i)}
      end

      # Options:
      # :tag => (optional) "httparty"
      # :count => (optional) Integer // Default: 15 Max: 100 
      def recent(options = nil)
        response= handle_errors { self.class.get('/recent', :query => options)}
        response["posts"]["post"].collect{|i| Rubycious::Post.new(i)}
      end

      # Options:
      # :tag => (optional) "tutorial"
      def dates(options = nil)
        response= handle_errors{ self.class.get('/dates', :query => options)}
        response["dates"]["date"].collect{|i| Rubycious::PostDate.new(i)}
      end

      # Options:
      # :url => (required) URL
      def suggest(options)
        response= handle_errors{ self.class.get('/suggest', :query => options)}
        response["suggest"]
      end
    end

    class Tag
      include ClientHelper

      base_uri "#{base_uri}/tags"

      def all
        response= handle_errors{ self.class.get('/get')}
        response["tags"]["tag"].collect do |tag| 
          t= Rubycious::Tag.new(tag)
        end
      end
      #Options:
      # :tag => (required)
      def delete(options)
        response= handle_errors{ self.class.get('/delete', :query => options)}
        true if response["result"] == "done"
      end
      
      #Options:
      # :old => (required)
      # :new => (required)
      def rename(options)
        response= handle_errors{ self.class.get('/rename', :query => options)}
        true if response["result"] == "done"
      end
    end

    class Bundles
      include ClientHelper

      base_uri "#{base_uri}/tags/bundles"
    end
  end

  class PostDate
    # Attributes:
    # date: Date
    # count: Integer

    attr_accessor :date, :count

    def initialize(options)
      @date= Date.parse(options["date"])
      @count= options["count"].to_i
    end
  end

  class Post
    # Attributes
    # :href => (required) http://somelink.com/somepage
    # :description => (required) This is a really cool link that I found
    # :time => (optional) CCYY-MM-DDThh:mm:ssZ filter by date
    # :hash => (optional) (only for find) MD5+MD5+....+MD5  Fetch multiple bookmarks by one or more URL MD5s regardless of date, separated by URL-encoded spaces (ie. '+').
    # :extended => (optional) This is some further information about the link
    # :tag => (optional) space seporated list of tags
    # :meta => (optional) meta hash

    def initialize(params = nil)
      @params= params
      @attributes= [:href, :description, :time, :hash, :extended, :tag, :meta]
    end

    def method_missing(name, *args, &block)
      if @attributes.include?(name)
        if name == :time
          Time.parse(@params[name.to_s])
        else
          @params[name.to_s]
        end
      else
        raise NoMethodError
      end
    end
  end

  class Tag
    attr_accessor :name, :count
    
    def initialize(options = {"tag" => nil})
      @name=  options["tag"]
      @count= options["count"]
    end

    def delete
      client= Rubycious::Client::Tag.new
      client.delete(:tag => @name)
    end

    def rename(new_name)
      client= Rubycious::Client::Tag.new
      client.rename(:old => @name, :new => new_name)
    end
  end
end
