# frozen_string_literal: true
module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Maxlength
      def maxlength(wrapper_options = nil)
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit
        nil
      end

      private

      def maximum_length_from_validation
        maxlength = options[:maxlength]
        if maxlength.is_a?(String) || maxlength.is_a?(Integer)
          maxlength
        else
          length_validator = find_length_validator
          maximum_length_value_from(length_validator)
        end
      end

      def find_length_validator
        find_validator(:length)
      end

      def has_tokenizer?(length_validator)
        length_validator.options[:tokenizer]
      end

      def maximum_length_value_from(length_validator)
        if length_validator
          length_validator.options[:is] || length_validator.options[:maximum]
        end
      end
    end
  end
end
