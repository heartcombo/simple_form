module SimpleForm
  module Components
    module Maxlength
      def maxlength
        if SimpleForm.html5 && has_maxlength?
          input_html_options[:maxlength] ||= maximum_length_from_validation
          input_html_options[:maxlength] ||= limit
        end

        nil
      end

      def has_maxlength?
        false
      end

      def limit
        column && column.limit
      end

      def maximum_length_from_validation
        return unless has_validators?

        length_validator = find_length_validator or return
        length_validator.options[:maximum]
      end

      def find_length_validator
        attribute_validators.find { |v| ActiveModel::Validations::LengthValidator === v }
      end
    end
  end
end
