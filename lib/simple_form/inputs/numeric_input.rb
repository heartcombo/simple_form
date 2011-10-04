module SimpleForm
  module Inputs
    class NumericInput < Base
      enable :placeholder

      def input
        add_size!
        if SimpleForm.html5
          input_html_options[:type] ||= "number"
          input_html_options[:step] ||= integer? ? 1 : "any"
          infer_attributes_from_validations!
        end
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_classes
        super.unshift("numeric")
      end

      private

      # Rails adds the size attr by default, if the :size key does not exist.
      def add_size!
        input_html_options[:size] ||= nil
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
        find_validator(ActiveModel::Validations::NumericalityValidator)
      end

      def evaluate_validator_option(option)
        if option.is_a?(Numeric)
          option
        elsif option.is_a?(Symbol)
          object.send(option)
        elsif option.respond_to?(:call)
          option.call(object)
        end
      end
    end
  end
end
