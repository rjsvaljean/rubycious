module Rubycious::Errors

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
