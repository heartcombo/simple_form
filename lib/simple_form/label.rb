module SimpleForm
  module Label

    private

      def generate_label
        return '' if skip_label?
        html_options = { :class => "#{@input_type} #{required_class}".strip }
        html_options[:for] = @options[:html][:id] if @options.key?(:html)
        label(@attribute, label_text, html_options)
      end

      def skip_label?
        @options[:label] == false || hidden_input?
      end

      def label_text
        required_text << (@options[:label] || translate_label)
      end

      def required_text
        attribute_required? ? translate_required_string : ''
      end

      def translate_label
        default = @object.try(:human_attribute_name, @attribute.to_s) || @attribute.to_s.humanize
        translate_form(:labels, default)
      end

      def translate_required_string
        translate(:required_string, :default =>
          %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr> ]
        )
      end

      def translate_required_text
        translate(:required_text, :default => 'required')
      end

      def translate_required_mark
        translate(:required_mark, :default => '*')
      end

  end
end
