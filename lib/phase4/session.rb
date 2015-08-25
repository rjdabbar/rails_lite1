require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash

    attr_accessor :cookie

    def initialize(req)
      cookie = req.cookies.find { |cookie| cookie.name == "_rails_lite_app"}
      if cookie
        @cookie = cookie
      else
        @cookie = WEBrick::Cookie.new("_rails_lite_app", {}.to_json )
      end
    end

    def [](key)
      JSON.parse(self.cookie.value)[key]
    end

    def []=(key, val)

      value = JSON.parse(self.cookie.value)

      value[key] = val
      self.cookie.value = value.to_json
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << cookie
    end
  end
end
