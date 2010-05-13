# @author Ratan Sebastian
# The Client module contains the Client classes Post, Tag and Bundle
module Rubycious::Client

  
  # The Post Client class that is used to make post related requests
  class Post
    include ClientHelper

    base_uri "#{base_uri}/posts"

    # Get the time of the last request
    # @return [Time] Returns the time of the last request in UTC
    def self.last_update
      response= self.new.handle_errors do
        get('/update')
      end
      Time.parse(response["update"]["time"])
    end

    # Save a URL
    # DO NOT call this method directly. To create a new URL call Rubycious::Post#save
    # @param [Hash] options for creating the URL with
    # @option options [String] :url  |required| http://somelink.com/somepage
    # @option options [String] :description  |required| This is a really cool link
    # @option options [String] :dt  |optional| Format: Time#iso8601 filter by date
    # @option options [String] :hash  |optional| MD5+MD5+....+MD5  Fetch multiple 
    #                       bookmarks by one or more URL MD5s regardless of date, 
    #                       separated by URL-encoded spaces (ie. '+').
    # @option options [String] :extended  |optional| This is some further information
    # @option options [String] :tags  |optional| space separated list of tags
    # @option options [String] :replace  |optional| yes/no Replace URL if already exists
    # @option options [String] :shared  |optional| yes/no Public/Private
    # @private
    # @see Rubycious::Post#save
    def save(options = {})
      handle_errors { self.class.get('/add', :query => options) }
    end
  
    # Use for getting one or more URLs on a single day matching the arguments
    # @param [Hash] options for searching for the URL (all optional)
    # @option options [String] :tag  "ruby+rails+httparty"
    # @option options [String] :dt  CCYY-MM-DDThh:mm:ssZ Time#iso8601
    # @option options [String] :url  URL
    # @option options [String] :hashes  "c0...d+2f970...fe+..+2f...9fe"
    # @option options [String] :meta  yes/no whether or not to get the meta hash tag
    # @return [Array<Rubycious::Post>] 
    # @see Time#iso8601
    def find_latest(options)
      response= handle_errors { self.class.get('/get', :query => options)}
      response["posts"]["post"].collect{|i| Rubycious::Post.new(i)}
    end

    # Use for searching all URLs
    # NOTE: Use Sparingly. Call the update function to see if you need to fetch this at all.
    # @todo Look into caching these results
    #       check the last update time before performing
    # @param [Hash] options for searching for the URL (all optional)
    # @option options [String] :tag |optional|  "ruby"
    # @option options [String] :start |optional|  Integer: Start returning posts this 
    #                                 many results into the set
    # @option options [String] :results |optional|  Integer: Return these many results 
    # @option options [String] :fromdt |optional|  Format: Time#iso8601: On this date or later
    # @option options [String] :todt |optional|  Format: Time#iso8601: On this date or earlier
    # @option options [String] :meta |optional|  yes/no: Include change detection signatures
    #                     on each item in a 'meta' attribute. Clients wishing to maintain a 
    #                     synchronized local store of bookmarks should retain the 
    #                     value of this attribute - its value will change when any 
    #                     significant field of the bookmark changes.
    # @return [Array<Rubycious::Post>]
    # @see Time#iso8601
    def find(options)
      response= handle_errors { self.class.get('/all', :query => options)}
      response["posts"]["post"].collect{|i| Rubycious::Post.new(i)}
    end

    # Use to get recent URLs
    # @param [Hash] options to filter recent URLs(all optional)
    # @option options [String] :tag |optional| "httparty"
    # @option options [String] :count (15) |optional| Default: 15 Max: 100 
    # @return [Array<Rubycious::Post>] 
    def recent(options = nil)
      response= handle_errors { self.class.get('/recent', :query => options)}
      response["posts"]["post"].collect{|i| Rubycious::Post.new(i)}
    end

    # Use to get a list of dates and number of posts on that date
    # @param [Hash] options to filter URLs(all optional)
    # @option options [String] :tag |optional| "tutorial"
    # @return [Array<Rubycious::PostDate>] 
    def dates(options = nil)
      response= handle_errors{ self.class.get('/dates', :query => options)}
      response["dates"]["date"].collect{|i| Rubycious::PostDate.new(i)}
    end

    # Use to get a list of Suggested tags for a URL
    # @param [Hash] options containing the URL
    # @option options [String] :url =|required| URL
    # @return [Hash] 
    # @example Sample returned hash:
    #     Rubycious::Client::Post.suggest("http://google.com")
    #     #=> {"recommended"=>["search", "google", "web", "reference", 
    #                     "internet", "tools", "research", "imported", 
    #                     "news", "images", "resources"], 
    #     "popular"=>["search", "google", "searchengine", "engine"],
    #     "network"=>["google", "searchengineo"]}

    def suggest(options = {})
      response= handle_errors{ self.class.get('/suggest', :query => options)}
      response["suggest"]
    end
  end

  # The Rubycious::Client::Tag class handles all requests, tag related
  class Tag
    include ClientHelper

    base_uri "#{base_uri}/tags"

    # Use to get all tags
    # @return [Array<Rubycious::Tag>] 
    def all
      response= handle_errors{ self.class.get('/get')}
      response["tags"]["tag"].collect do |tag| 
        t= Rubycious::Tag.new(tag)
      end
    end

    # @param [Hash] options to identify the tag to delete
    # @option options [String] :tag |required|
    # @return [TrueClass, FalseClass]
    def delete(options)
      response= handle_errors{ self.class.get('/delete', :query => options)}
      if response["result"] == "done"
        true
      else
        false
      end
    end

    # @param [Hash] options of the old and the new name for a tag
    # @option options [String] :old |required|
    # @option options [String] :new |required|
    # @return [TrueClass, FalseClass]
    def rename(options)
      response= handle_errors{ self.class.get('/rename', :query => options)}
      if response["result"] == "done"
        true
      else
        false
      end
    end
  end

  # Will Implement the bundles part of the API when done
  # @todo To Be Implemented
  class Bundles
    include ClientHelper

    base_uri "#{base_uri}/tags/bundles"
  end
end
