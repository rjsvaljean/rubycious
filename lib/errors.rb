module Rubycious::Errors

  # Raised whenever there is some sort of failure on the remote end
  class DeliciousError < StandardError
  end

  # Raised when del.icio.us returns an access denied
  class AuthenticationError < StandardError
  end

  # surrounds all HTTParty#get calls to check for failure or throttling by del.icio.us
  # @yield The block contains and network calls to the del.icio.us API
  # @todo Make more stringent and give better error messages
  # @raise [DeliciousError]
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
