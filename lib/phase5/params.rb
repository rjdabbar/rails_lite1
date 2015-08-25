require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    attr_accessor :params
    attr_reader :req

    def initialize(req, route_params = {})
      @req = req
      @params = route_params

      @params.merge!(parse_www_encoded_form(req.query_string))
      @params.merge!(parse_www_encoded_form(req.body))
    end

    def [](key)
      @params = @params.with_indifferent_access
      @params[key]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      return {} if www_encoded_form.nil?
      ary = URI.decode_www_form(www_encoded_form)

      params = {}

      ary.each do |keys, val|
        current_hash = params
        parsed_keys = parse_key(keys)
        parsed_keys.each_with_index do |key, idx|
          if current_hash[key]
            current_hash = current_hash[key]
          elsif idx == parsed_keys.size - 1
            current_hash[key] = val
          else
            current_hash[key] = {}
            current_hash = current_hash[key]
          end
        end
      end
      params
    end


    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
