module SimpleForm
  module Inputs
    class FileInput < Base
      def input(context = nil)
        merged_input_options = merge_wrapper_options(input_html_options, context)

        @builder.file_field(attribute_name, merged_input_options)
      end
    end
  end
end
