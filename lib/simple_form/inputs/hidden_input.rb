module SimpleForm
  module Inputs
    class HiddenInput < Base
      disable :label, :errors, :hint, :required

      def input
        @builder.hidden_field(attribute_name, input_html_options)
      end

      private

      def required_class
        nil
      end
    end
  end
end
