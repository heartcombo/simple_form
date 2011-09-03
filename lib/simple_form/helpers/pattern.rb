module SimpleForm
  module Helpers
    # Helper methods for pattern.
    module Pattern #:nodoc:
      private
      
      def add_pattern!
        input_html_options[:pattern] ||= pattern_source if validate_pattern?
      end

      def validate_pattern?
        has_validators? && SimpleForm.html5 &&
          SimpleForm.browser_validations && pattern_validator.present?
      end

      def pattern_source
        pattern_validator.options[:with].source
      end

      def pattern_validator
        @pattern_validator ||= attribute_validators.find { |v| ActiveModel::Validations::FormatValidator === v }
      end
    end
  end
end