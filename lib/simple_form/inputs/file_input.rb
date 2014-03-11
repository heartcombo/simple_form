module SimpleForm
  module Inputs
    class FileInput < Base
      def input(context)
        @builder.file_field(attribute_name, merged_input_options(context.options))
      end
    end
  end
end
