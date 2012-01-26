module SimpleForm
  module Inputs
    class BooleanInput < Base
      def input
        @builder.check_box(attribute_name, input_html_options)
      end

      def label_input
        if options[:label] == false
          input
        elsif nested_boolean_style?
          @builder.label(attribute_name) { input }
        else
          input + label
        end
      end

      private

      # Booleans are not required by default because in most of the cases
      # it makes no sense marking them as required. The only exception is
      # Terms of Use usually presented at most sites sign up screen.
      def required_by_default?
        false
      end
    end
  end
end
