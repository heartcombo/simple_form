module SimpleForm
  module Inputs
    class StringInput < Base
      enable :placeholder

      def input
        input_html_options[:type] ||= input_type if SimpleForm.html5 && !string?
        add_maxlength!
        add_pattern!
        add_size!
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_classes
        string? ? super : super.unshift("string")
      end

      private

      def string?
        input_type == :string
      end
    end
  end
end
