module SimpleForm
  module Inputs
    class DateTimeInput < Base
      def input
        @builder.send(:"#{input_type}_select", attribute_name, input_options, input_html_options)
      end

      private

      def has_required?
        false
      end

      def label_target
        case input_type
        when :date, :datetime
          "#{attribute_name}_1i"
        when :time
          "#{attribute_name}_4i"
        end
      end
    end
  end
end
