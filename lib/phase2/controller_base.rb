module Phase2
  class ControllerBase
    attr_reader :req, :res

    # Setup the controller
    def initialize(req, res)
      @req, @res = req, res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      @already_built_response ||= false
    end

    # Set the response status code and header
    def redirect_to(url)
      if !already_built_response?
        self.res.header["location"] = url
        self.res.status = 302
        @already_built_response = true
      else
        raise
      end
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      if !already_built_response?
        p self
        self.res.content_type = content_type
        self.res.body = content
        @already_built_response = true
      else
        raise
      end
    end
  end
end
