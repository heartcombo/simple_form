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
          if has_validators? && (pattern_validator = find_pattern_validator)
            pattern_validator.options[:with].source
          end
        else
          options[:pattern]
        end
      end

      def find_pattern_validator
        find_validator(ActiveModel::Validations::FormatValidator)
      end
    end
  end
end
