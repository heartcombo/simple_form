module SimpleForm
  module Inputs
    class BooleanInput < Base
      def input
        build_check_box
      end

      def label_input
        if options[:label] == false
          input
        elsif nested_boolean_style?
          @builder.label(label_target, label_html_options) { build_check_box(nil) + label_text }
        else
          input + label
        end
      end

      private

      # Build a checkbox tag using default unchecked value. This allows us to
      # reuse the method for nested boolean style, but with nil unchecked value,
      # which won't generate the hidden checkbox (only in Rails > 3.2.1).
      def build_check_box(unchecked_value='0')
        @builder.check_box(attribute_name, input_html_options, '1', unchecked_value)
      end

      # Booleans are not required by default because in most of the cases
      # it makes no sense marking them as required. The only exception is
      # Terms of Use usually presented at most sites sign up screen.
      def required_by_default?
        false
      end
    end
  end
end
