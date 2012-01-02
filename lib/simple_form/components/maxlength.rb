module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Maxlength
      def maxlength
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit
        nil
      end

      private

      def maximum_length_from_validation
        if options[:maxlength] == true
          if (length_validator = find_length_validator) && !length_validator.options[:tokenizer]
            length_validator.options[:maximum]
          end
        else
          options[:maxlength]
        end
      end

      def find_length_validator
        find_validator(ActiveModel::Validations::LengthValidator)
      end
    end
  end
end
