module SimpleForm
  module Inputs
    class HiddenInput < Base
      disable :label, :errors, :hint, :required

      def input(context=nil)
        if context
          merged_input_options = merge_wrapper_options(input_html_options, context.options)
        else
          merged_input_options = input_html_options
        end

        @builder.hidden_field(attribute_name, merged_input_options)
      end

      private

      def required_class
        nil
      end
    end
  end
end
