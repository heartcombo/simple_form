module SimpleForm
  module Inputs
    class NumericInput < Base
      enable :placeholder, :min_max

      def input(context=nil)
        input_html_classes.unshift("numeric")
        if html5?
          input_html_options[:type] ||= "number"
          input_html_options[:step] ||= integer? ? 1 : "any"
        end

        if context
          merged_input_options = merge_wrapper_options(input_html_options, context.options)
        else
          merged_input_options = input_html_options
        end

        @builder.text_field(attribute_name, merged_input_options)
      end
    end
  end
end
