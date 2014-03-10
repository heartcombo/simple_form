module SimpleForm
  module Inputs
    class FileInput < Base
      def input(context)
        @builder.file_field(attribute_name, input_html_options)
      end
    end
  end
end
