module SimpleForm
  module Inputs
    class FileInput < Base
      def input(context=nil)
        if context
          merged_input_options = merged_input_options(context.options)
        else
          merged_input_options = input_html_options
        end

        @builder.file_field(attribute_name, merged_input_options)
      end
    end
  end
end
