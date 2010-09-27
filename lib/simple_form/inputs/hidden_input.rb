module SimpleForm
  module Inputs
    class HiddenInput < Base
      def render
        @builder.hidden_field(attribute_name, input_html_options)
      end
      alias :input :render
    end
  end
end
