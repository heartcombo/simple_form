# frozen_string_literal: true
module SimpleForm
  module Inputs
    class PriorityInput < CollectionSelectInput
      def input(wrapper_options = nil)
        merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

        send(:"#{input_type}_input", merged_input_options)
      end

      def input_priority
        options[:priority] || SimpleForm.send(:"#{input_type}_priority")
      end

      protected

      def country_input(merged_input_options)
        @builder.send(:country_select,
                      attribute_name,
                      input_options.merge(priority_countries: input_priority),
                      merged_input_options)
      end

      def time_zone_input(merged_input_options)
        @builder.send(:time_zone_select,
                      attribute_name,
                      input_priority,
                      input_options,
                      merged_input_options)
      end

      def skip_include_blank?
        super || input_priority.present?
      end
    end
  end
end
