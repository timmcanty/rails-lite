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
    def initialize(req, route_params = {})
      query_params = parse_www_encoded_form(req.query_string) if req.query_string
      query_params ||= {}

      body_params = parse_www_encoded_form(req.body) if req.body
      body_params ||= {}

      @params = route_params.merge(query_params).merge(body_params)
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    # def parse_www_encoded_form(www_encoded_form)
    #   query = URI.decode(www_encoded_form).split(/[=&]/)
    #   hash = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc)}
    #
    #   query.each_slice(2) do |key,value|
    #     keys = parse_key(key)
    #     eval("hash[\"#{keys.join("\"][\"")}\"] = value")
    #   end
    #
    #   hash
    # end

    def parse_www_encoded_form(www_encoded_form)
      query = URI.decode(www_encoded_form).split(/[=&]/)
      hash = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc)}

      query.each_slice(2) do |key,value|
        keys = parse_key(key)
        current_hash = hash

        keys[0..-2].each_index do |i|
          current_hash[keys[i]]
          current_hash = current_hash[keys[i]]
        end

        current_hash[keys[-1]] = value

      end

      hash

    end












    def build_nested_hash(hash,key)
      hash[key] = Hash.new { |h,k| h[k] = Hash.new}
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
