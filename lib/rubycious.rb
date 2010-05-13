require 'httparty'

ROOT_DIR= File.join(File.dirname(__FILE__),'..')

module Rubycious
  # This is type for calls to Rubycious::Client::Post#dates
  class PostDate

    # @return [Date]
    attr_accessor :date
    # @return [Integer]
    attr_accessor :count

    # @param [Hash] options to create the PostDate
    # @option options [String] Format: "yyyy-mm-dd"
    # @option options [String] Integer as a string
    def initialize(options)
      @date= Date.parse(options["date"])
      @count= options["count"].to_i
    end
  end

  # This is the class that will model an URL returned by the API
  class Post

    # The methods [:href, :description, :time, :hash, :extended, :tag, :meta]
    # can be called on a Post object
    # @param [Hash] options to create the Post
    # @option options [String] :href |required for #save| http://somelink.com/somepage
    # @option options [String] :description |required for #save| This is a really cool link that I found
    # @option options [String] :time  |optional| CCYY-MM-DDThh:mm:ssZ filter by date
    # @option options [String] :hash  |optional| (only for find) MD5+MD5+....+MD5  
    #                                Fetch multiple bookmarks by one or more URL MD5s 
    #                                regardless of date, separated by URL-encoded spaces (ie. '+').
    # @option options [String] :extended  |optional| This is some further information about the link
    # @option options [String] :tag  |optional| space seporated list of tags
    # @option options [String] :meta  |optional| meta hash
    def initialize(params = nil)
      @params= params
      @attributes= [:href, :description, :time, :hash, :extended, :tag, :meta]
    end

    # Use to create a new URL
    # @todo check for url and description before saving and raise errors
    def save
      Rubycious::Client::Post.new.save(@params)
    end

    # The methods [:href, :description, :time, :hash, :extended, :tag, :meta]
    # can be called on a Post object
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

  # Models Tags returned by the API
  class Tag

    # @return [String] name of the tag
    # @return [Integer] number of times the tag has been used
    attr_accessor :name
    attr_accessor :count
   
    # @param [Hash] options for creating the Tag
    # @option options [String] "tag" |required| The name of the tag
    # @option options [String] "count" |optional| The number of times the tag has been used
    def initialize(options = {"tag" => nil})
      @name=  options["tag"]
      @count= options["count"].to_i
      @client= Rubycious::Client::Tag.new
    end

    # @return [TrueClass, FalseClass]
    def delete
      client.delete(:tag => @name)
    end

    # @param [String] The new name of the tag
    # @return [TrueClass, FalseClass]
    def rename(new_name)
      client.rename(:old => @name, :new => new_name)
    end
  end
end

load File.join(ROOT_DIR, 'lib', 'errors.rb')
load File.join(ROOT_DIR, 'lib', 'client_helper.rb')
load File.join(ROOT_DIR, 'lib', 'client.rb')
