module SimpleForm
  module Inputs
    class NumericInput < Base
      enable :placeholder, :min_max

      def input(context)
        input_html_classes.unshift("numeric")
        if html5?
          input_html_options[:type] ||= "number"
          input_html_options[:step] ||= integer? ? 1 : "any"
        end

        merged_input_options = merged_input_options(context.options)

        @builder.text_field(attribute_name, merged_input_options)
      end

      private
    end
  end
end
