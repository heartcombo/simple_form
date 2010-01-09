module SimpleForm
  module Inputs
    # Handles common text field inputs, as String, Numeric, Float and Decimal.
    class TextFieldInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_options
        input_options = super
        input_options[:max_length] ||= column.limit if column
        input_options
      end
    end
  end
end