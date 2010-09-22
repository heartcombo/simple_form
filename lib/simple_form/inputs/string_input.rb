module SimpleForm
  module Inputs
    class StringInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_options
        input_options = super
        input_options[:size]        ||= [limit, SimpleForm.default_input_size].compact.min
        input_options[:maxlength]   ||= limit if limit
        input_options[:type]        ||= input_type unless input_type == :string
        input_options[:placeholder] ||= placeholder if placeholder
        input_options
      end

      def input_html_classes
        input_type == :string ? super : super.unshift("string")
      end

    protected

      def limit
        column && column.limit
      end

      def placeholder
        @placeholder ||= options[:placeholder] || translate(:placeholder)
      end
    end
  end
end
