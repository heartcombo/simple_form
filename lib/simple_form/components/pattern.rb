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
        if options[:pattern] == true
          if pattern_validator = find_pattern_validator
            evaluate_format_validator_option(pattern_validator.options[:with]).source
          end
        else
          options[:pattern]
        end
      end

      def find_pattern_validator
        find_validator(ActiveModel::Validations::FormatValidator)
      end

      def evaluate_format_validator_option(option)
        if option.is_a?(Regexp)
          option
        elsif option.respond_to?(:call)
          option.call(object)
        end
      end
    end
  end
end
