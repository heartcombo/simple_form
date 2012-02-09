module SimpleForm
  module Inputs
    class DateTimeInput < Base
      def input
        @builder.send(:"#{input_type}_select", attribute_name, input_options, input_html_options)
      end

      def has_required?
        false
      end

      private

      def label_target
        case input_type
        when :date, :datetime
          date_order = input_options[:order] || I18n.t('date.order')
          type = date_order.first
          position = ActionView::Helpers::DateTimeSelector::POSITION[type]
          "#{attribute_name}_#{position}i"
        when :time
          "#{attribute_name}_4i"
        end
      end
    end
  end
end
