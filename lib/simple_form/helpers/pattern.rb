module SimpleForm
  module Helpers
    # Helper methods for pattern.
    module Pattern #:nodoc:
      private

      def add_pattern!
        input_html_options[:pattern] ||= pattern_source if options[:pattern]
      end

      def pattern_source
        if options[:pattern] == true
          if has_validators? && pattern_validator
            pattern_validator.options[:with].source
          else
            raise "Could not find format validator for #{attribute_name}"
          end
        else
          options[:pattern]
        end
      end

      def pattern_validator
        @pattern_validator ||= find_validator(ActiveModel::Validations::FormatValidator)
      end
    end
  end
end
