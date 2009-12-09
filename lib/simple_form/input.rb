module SimpleForm
  module Input
    Mapping = Struct.new(:method, :collection, :options)

    MAPPINGS = {
      :boolean  => Mapping.new(:check_box, false, false),
      :text     => Mapping.new(:text_area, false, false),
      :datetime => Mapping.new(:datetime_select, false, true),
      :date     => Mapping.new(:date_select, false, true),
      :time     => Mapping.new(:time_select, false, true),
      :password => Mapping.new(:password_field, false, false),
      :hidden   => Mapping.new(:hidden_field, false, false),
      :select   => Mapping.new(:collection_select, true, true),
      :radio    => Mapping.new(:collection_radio, true, false),
      # Do we need integer and numeric?
      :integer  => Mapping.new(:text_field, false, false),
      :numeric  => Mapping.new(:text_field, false, false),
      :string   => Mapping.new(:text_field, false, false)
    }

    private

      def generate_input
        html_options = @options[:html] || {}
        html_options[:class] = default_css_classes(html_options[:class])
        @options[:options] ||= {}

        mapping = MAPPINGS[@input_type]
        raise "Invalid input type #{@input_type.inspect}" unless mapping

        args = [ @attribute ]

        if mapping.collection
          collection = @options[:collection] || boolean_collection
          detect_collection_methods(collection, @options)
          args.push(collection, @options[:value_method], @options[:label_method])
        end

        args << @options[:options] if mapping.options
        args << html_options

        send(mapping.method, *args)
      end

      def boolean_collection
        [[translate(:true, :default => 'Yes'), true],
         [translate(:false, :default => 'No'), false]]
      end

      def detect_collection_methods(collection, options)
        sample = collection.first

        if sample.is_a?(Array) # TODO Test me
          options[:label_method] ||= :first
          options[:value_method] ||= :last
        elsif sample.is_a?(String) # TODO Test me
          options[:label_method] ||= :to_s
          options[:value_method] ||= :to_s
        else # TODO Implement collection label methods or something similar
          options[:label_method] ||= :to_s
          options[:value_method] ||= :to_s
        end
      end

      def collection_radio(attribute, collection, value_method, text_method, html_options={})
        collection.inject('') do |result, item|
            value = item.send value_method
            text  = item.send text_method

            result << radio_button(attribute, value, html_options) <<
                      label("#{attribute}_#{value}", text, :class => default_css_classes)
        end
      end

  end
end
