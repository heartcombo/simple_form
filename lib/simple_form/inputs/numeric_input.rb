module SimpleForm
  module Inputs
    class NumericInput < Base
      def input
        @builder.text_field(attribute_name, input_html_options)
      end

      def input_html_options
        input_options = super
        input_options[:type] ||= "number"
        input_options[:size] ||= SimpleForm.default_input_size

        infer_attrs_from_validations(input_options)

        input_options
      end

      def input_html_classes
        super.unshift("numeric")
      end

    protected

      def infer_attrs_from_validations(input_options)
        model_class = @builder.object.class

        # The model should include ActiveModel::Validations.
        return unless model_class.respond_to?(:validators_on)

        num_validator = find_numericality_validator(model_class) or return

        @val_options = num_validator.__send__(:options)

        input_options[:min]  ||= minimum_value
        input_options[:max]  ||= maximum_value
        input_options[:step] ||= integer? && 1
      end

      def integer?
        input_type == :integer
      end

      def minimum_value
        return @val_options[:greater_than] + 1 if integer? && @val_options[:greater_than]
        @val_options[:greater_than_or_equal_to]
      end

      def maximum_value
        return @val_options[:less_than] - 1 if integer? && @val_options[:less_than]
        @val_options[:less_than_or_equal_to]
      end

      def find_numericality_validator(model_class)
        validators = model_class.validators_on(attribute_name)
        validators.find {|v| ActiveModel::Validations::NumericalityValidator === v }
      end
    end
  end
end
