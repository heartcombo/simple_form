module SimpleForm
  module Inputs
    class TextInput < Base
      enable :placeholder, :maxlength

      def input(context)
        @builder.text_area(attribute_name, merged_input_options(context.options))
      end
    end
  end
end
