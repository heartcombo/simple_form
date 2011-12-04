module SimpleForm
  module Inputs
    class StringInput < Base
      enable :placeholder, :maxlength, :pattern

      def input
        unless string?
          input_html_classes.unshift("string")
          input_html_options[:type] ||= input_type if html5?
        end

        add_size!
        @builder.text_field(attribute_name, input_html_options)
      end

      private

      def string?
        input_type == :string
      end
    end
  end
end
