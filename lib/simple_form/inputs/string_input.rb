module SimpleForm
  module Inputs
    class StringInput < Base
      def input
        input_html_options[:size]      ||= [limit, SimpleForm.default_input_size].compact.min
        input_html_options[:maxlength] ||= limit if limit
        input_html_options[:type]      ||= input_type unless string?

        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_classes
        string? ? super : super.unshift("string")
      end

    protected

      def limit
        column && column.limit
      end

      def has_placeholder?
        placeholder_present?
      end

      def string?
        input_type == :string
      end
    end
  end
end
