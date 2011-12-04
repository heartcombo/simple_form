module SimpleForm
  module Inputs
    class FileInput < Base
      def input
        @builder.file_field(attribute_name, input_html_options)
      end

      def has_placeholder?
        false
      end
    end
  end
end
