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
      :select   => Mapping.new(:select, true, true),
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
        @options[:collection] ||= boolean_collection

        mapping = MAPPINGS[@input_type]
        raise "Invalid input type #{@input_type.inspect}" unless mapping

        args = [ @attribute ]
        args << @options[:collection] if mapping.collection
        args << @options[:options]    if mapping.options
        args << html_options

        send(mapping.method, *args)
      end

      def boolean_collection
        [['Yes', true], ['No', false]]
      end

      def collection_radio(attribute, collection, html_options)
        collection.inject('') do |result, (text, value)|
            result << radio_button(attribute, value, html_options) <<
                      label("#{attribute}_#{value}", text, :class => default_css_classes)
        end
      end

  end
end
