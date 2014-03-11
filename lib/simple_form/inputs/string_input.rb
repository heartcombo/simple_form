module SimpleForm
  module Inputs
    class StringInput < Base
      enable :placeholder, :maxlength, :pattern

      def input(context)
        unless string?
          input_html_classes.unshift("string")
          input_html_options[:type] ||= input_type if html5?
        end

        merged_input_options = merged_input_options(context.options)

        @builder.text_field(attribute_name, merged_input_options)
      end

      private

      def string?
        input_type == :string
      end
    end
  end
end
