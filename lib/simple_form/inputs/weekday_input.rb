# frozen_string_literal: true
module SimpleForm
  module Inputs
    class WeekdayInput < CollectionSelectInput
      enable :placeholder

      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        @builder.weekday_select(attribute_name, input_options, merged_input_options)
      end
    end
  end
end
