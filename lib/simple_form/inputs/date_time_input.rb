# frozen_string_literal: true
module SimpleForm
  module Inputs
    class DateTimeInput < Base
      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        if html5?
          @builder.send(:"#{input_type}_field", attribute_name, merged_input_options)
        else
          @builder.send(:"#{input_type}_select", attribute_name, input_options, merged_input_options)
        end
      end

      private

      def label_target
        return attribute_name if html5?

        position = case input_type
        when :date, :datetime
          date_order = input_options[:order] || I18n.t('date.order')
          date_order.first.to_sym
        else
          :hour
        end

        position = ActionView::Helpers::DateTimeSelector::POSITION[position]
        "#{attribute_name}_#{position}i"
      end

    end
  end
end
