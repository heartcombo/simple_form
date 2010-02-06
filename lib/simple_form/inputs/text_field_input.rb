module SimpleForm
  module Inputs
    # Handles common text field inputs, as String, Numeric, Float and Decimal.
    class TextFieldInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_options
        input_options = super
        if text_type? && column && column.limit
          input_options[:size]      ||= [column.limit, SimpleForm.default_input_size].min
          input_options[:maxlength] ||= column.limit
        else
          input_options[:size]      ||= SimpleForm.default_input_size
        end
        input_options
      end

    protected

      def text_type?
        [:string, :email, :url].include?(input_type)
      end
    end
  end
end