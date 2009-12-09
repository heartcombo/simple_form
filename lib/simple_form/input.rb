module SimpleForm
  module Input
    Mapping = Struct.new(:method, :arity)

    MAPPINGS = {
      :boolean  => Mapping.new(:check_box, 2),
      :text     => Mapping.new(:text_area, 2),
      :datetime => Mapping.new(:datetime_select, 3),
      :date     => Mapping.new(:date_select, 3),
      :time     => Mapping.new(:time_select, 3),
      :password => Mapping.new(:password_field, 2),
      :hidden   => Mapping.new(:hidden_field, 2),
      # Do we need integer and numeric?
      :integer  => Mapping.new(:text_field, 2),
      :numeric  => Mapping.new(:text_field, 2),
      :string   => Mapping.new(:text_field, 2)
    }

    private

      def generate_input
        html_options = @options[:html] || {}
        html_options[:class] = default_css_classes(html_options[:class])
        @options[:options] ||= {}

        # TODO Move boolean_collection to form_helper
        if @input_type == :radio
          return boolean_collection.inject('') do |result, (text, value)|
            result << radio_button(@attribute, value, html_options) <<
                      label("#{@attribute}_#{value}", text, :class => default_css_classes)
          end
        end

        mapping = MAPPINGS[@input_type]
        raise "Invalid input type #{@input_type.inspect}" unless mapping

        case mapping.arity
          when 3
            send(mapping.method, @attribute, @options[:options], html_options)
          when 2
            send(mapping.method, @attribute, html_options)
        end
      end

      def boolean_collection
        [['Yes', true], ['No', false]]
      end

  end
end
