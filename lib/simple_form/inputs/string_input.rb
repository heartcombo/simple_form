module SimpleForm
  module Inputs
    class StringInput < Base
      def input
        input_html_options[:size]      ||= [limit, SimpleForm.default_input_size].compact.min
        input_html_options[:pattern]   ||= pattern_validator if validate_pattern?
        input_html_options[:type]      ||= input_type if SimpleForm.html5 && !string?
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_classes
        string? ? super : super.unshift("string")
      end

    protected

      def has_maxlength?
        true
      end

      def has_placeholder?
        placeholder_present?
      end

      def string?
        input_type == :string
      end

      def validate_pattern?
        return unless has_validators?

        SimpleForm.html5 && SimpleForm.browser_validations && find_pattern_validator.present?
      end

      def pattern_validator
        find_pattern_validator.options[:with].source
      end

      def find_pattern_validator
        attribute_validators.find { |v| ActiveModel::Validations::FormatValidator === v }
      end
    end
  end
end
