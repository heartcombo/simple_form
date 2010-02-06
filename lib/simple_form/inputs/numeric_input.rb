module SimpleForm
  module Inputs
    class NumericInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_options
        input_options = super
        input_options[:class]  = "numeric #{input_options[:class]}"
        input_options[:size] ||= SimpleForm.default_input_size
        input_options
      end
    end
  end
end