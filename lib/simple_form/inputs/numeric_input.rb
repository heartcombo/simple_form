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

        options = num_validator.__send__(:options)

        input_options[:min]  ||= options[:greater_than_or_equal_to]
        input_options[:max]  ||= options[:less_than_or_equal_to]
        input_options[:step] ||= options[:only_integer] && 1
      end

      def find_numericality_validator(model_class)
        validators = model_class.validators_on(attribute_name)
        validators.find {|v| ActiveModel::Validations::NumericalityValidator === v }
      end
    end
  end
end
