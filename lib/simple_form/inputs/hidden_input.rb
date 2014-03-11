module SimpleForm
  module Inputs
    class HiddenInput < Base
      disable :label, :errors, :hint, :required

      def input(context)
        @builder.hidden_field(attribute_name, merged_input_options(context.options))
      end

      private

      def required_class
        nil
      end
    end
  end
end
