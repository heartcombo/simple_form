module SimpleForm
  Mapping = Struct.new(:method, :collection, :options)

  module MapType
    def mappings
      @mappings ||= {}
    end

    def map_type(type, options)
      raise ArgumentError, "You need to give :to as option to map_type" unless options[:to]
      mappings[type] = Mapping.new(options[:to], options[:collection] || false, options[:options] || false)
    end
  end
end