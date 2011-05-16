module SimpleForm
  module Inputs
    class NumericInput < Base
      def input
        input_html_options[:type] ||= "number" if SimpleForm.html5
        input_html_options[:size] ||= SimpleForm.default_input_size
        input_html_options[:step] ||= integer? ? 1 : "any" if SimpleForm.html5
        infer_attributes_from_validations! if SimpleForm.html5
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_classes
        super.unshift("numeric")
      end

    protected

      def has_placeholder?
        placeholder_present?
      end

      def infer_attributes_from_validations!
        return unless has_validators?

        numeric_validator = find_numericality_validator or return
        validator_options = numeric_validator.options

        input_html_options[:min] ||= minimum_value(validator_options)
        input_html_options[:max] ||= maximum_value(validator_options)
      end

      def integer?
        input_type == :integer
      end

      def minimum_value(validator_options)
        if integer? && validator_options.key?(:greater_than)
          evaluate_validator_option(validator_options[:greater_than]) + 1
        else
          evaluate_validator_option(validator_options[:greater_than_or_equal_to])
        end
      end

      def maximum_value(validator_options)
        if integer? && validator_options.key?(:less_than)
          evaluate_validator_option(validator_options[:less_than]) - 1
        else
          evaluate_validator_option(validator_options[:less_than_or_equal_to])
        end
      end

      def find_numericality_validator
        attribute_validators.find { |v| ActiveModel::Validations::NumericalityValidator === v }
      end

      private

      def evaluate_validator_option(option)
        return option if option.is_a?(Numeric)
        return object.send(option) if option.is_a?(Symbol)
        return option.call(object) if option.respond_to?(:call)
      end
    end
  end
end
