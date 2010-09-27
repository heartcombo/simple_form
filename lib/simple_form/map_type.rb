module SimpleForm
  module MapType
    def mappings
      @mappings ||= {}
    end

    def map_type(*types)
      map_to = types.extract_options![:to]
      raise ArgumentError, "You need to give :to as option to map_type" unless map_to
      types.each { |t| mappings[t] = map_to }
    end
  end
end
