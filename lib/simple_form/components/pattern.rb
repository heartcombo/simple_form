# frozen_string_literal: true
module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Pattern
      def pattern(wrapper_options = nil)
        input_html_options[:pattern] ||= pattern_source
        nil
      end

      private

      def pattern_source
        pattern = options[:pattern]
        if pattern.is_a?(String)
          pattern
        elsif (pattern_validator = find_pattern_validator) && (with = pattern_validator.options[:with])
          resolve_validator_value(with).source
        end
      end

      def find_pattern_validator
        find_validator(:format)
      end
    end
  end
end
