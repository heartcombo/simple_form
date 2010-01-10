module SimpleForm
  module MapType
    def mappings
      @mappings ||= {}
    end

    def map_type(*types)
      options = types.extract_options!
      raise ArgumentError, "You need to give :to as option to map_type" unless options[:to]
      types.each { |t| mappings[t] = options[:to] }
    end
  end
end