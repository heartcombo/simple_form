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
        obj = @builder.object

        return unless obj.class.respond_to?(:validators_on)

        validators = obj.class.validators_on(attribute_name)
        num_validator = validators.find {|v| v.is_a?(ActiveModel::Validations::NumericalityValidator) }

        return if num_validator.nil?

        options = num_validator.__send__(:options)

        input_options[:min] ||= options[:greater_than_or_equal_to]
        input_options[:max] ||= options[:less_than_or_equal_to]
      end
    end
  end
end
