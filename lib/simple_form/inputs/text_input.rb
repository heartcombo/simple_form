module SimpleForm
  module Inputs
    class TextInput < Base
      enable :placeholder, :maxlength

      def input(context=nil)
        merged_input_options = merge_wrapper_options(input_html_options, context)

        @builder.text_area(attribute_name, merged_input_options)
      end
    end
  end
end
