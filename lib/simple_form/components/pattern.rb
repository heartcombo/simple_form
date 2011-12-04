module SimpleForm
  module Components
    module Pattern
      def pattern
        input_html_options[:pattern] ||= pattern_source
        nil
      end

      private

      def pattern_source
        if has_validators? && (pattern_validator = find_pattern_validator)
          pattern_validator.options[:with].source
        end
      end

      def find_pattern_validator
        find_validator(ActiveModel::Validations::FormatValidator)
      end
    end
  end
end
