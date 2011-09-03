module SimpleForm
  module Inputs
    class HiddenInput < Base
      def render
        @builder.hidden_field(attribute_name, input_html_options)
      end
      alias :input :render

      private

      def attribute_required?
        false
      end

      def required_class
        nil
      end
    end
  end
end
