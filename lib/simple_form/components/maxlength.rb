module SimpleForm
  module Components
    module Maxlength
      def maxlength
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit if has_maxlength?
        nil
      end

      def has_maxlength?
        true
      end

      private

      def maximum_length_from_validation
        if has_validators? && (length_validator = find_length_validator)
          length_validator.options[:maximum]
        end
      end

      def find_length_validator
        find_validator(ActiveModel::Validations::LengthValidator)
      end
    end
  end
end
