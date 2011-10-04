module SimpleForm
  module Inputs
    class TextInput < Base
      enable :placeholder

      def input
        add_maxlength!
        @builder.text_area(attribute_name, input_html_options)
      end
    end
  end
end
