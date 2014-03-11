module SimpleForm
  module Inputs
    class PasswordInput < Base
      enable :placeholder, :maxlength

      def input(context=nil)
        if context
          merged_input_options = merge_wrapper_options(input_html_options, context.options)
        else
          merged_input_options = input_html_options
        end

        @builder.password_field(attribute_name, merged_input_options)
      end
    end
  end
end
