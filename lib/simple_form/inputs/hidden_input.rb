module SimpleForm
  module Inputs
    class HiddenInput < Base
      def label; "" end
      def error; end
      def hint;  end

      def input
        @builder.hidden_field(attribute_name, input_html_options)
      end

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
