module SimpleForm
  module Inputs
    class TextInput < Base
      enable :placeholder, :maxlength

      def input
        @builder.text_area(attribute_name, input_html_options)
      end
    end
  end
end
