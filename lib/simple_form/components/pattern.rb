module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Pattern
      def pattern
        input_html_options[:pattern] ||= pattern_source
        nil
      end

      private

      def pattern_source
        pattern = options[:pattern]
        if pattern.is_a?(String)
          pattern
        elsif pattern_validator = find_pattern_validator
          evaluate_format_validator_option(pattern_validator.options[:with]).source
        end
      end

      def find_pattern_validator
        find_validator(ActiveModel::Validations::FormatValidator)
      end

      def evaluate_format_validator_option(option)
        if option.respond_to?(:call)
          option.call(object)
        else
          option
        end
      end
    end
  end
end
