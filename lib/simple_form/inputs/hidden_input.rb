module SimpleForm
  module Inputs
    # Handles hidden input.
    class HiddenInput < Base
      def render
        @builder.hidden_field(attribute_name, input_html_options)
      end
      alias :input :render
    end
  end
end