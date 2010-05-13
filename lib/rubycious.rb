require 'httparty'

ROOT_DIR= File.join(File.dirname(__FILE__),'..')

module Rubycious
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

load File.join(ROOT_DIR, 'lib', 'errors.rb')
load File.join(ROOT_DIR, 'lib', 'client_helper.rb')
load File.join(ROOT_DIR, 'lib', 'client.rb')

