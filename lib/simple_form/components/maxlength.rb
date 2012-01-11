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
        maxlength = options[:maxlength]
        if maxlength.is_a?(String) || maxlength.is_a?(Integer)
          maxlength
        else
          length_validator = find_length_validator

          if length_validator && !has_tokenizer?(length_validator)
            length_validator.options[:is] || length_validator.options[:maximum]
          end
        end
      end

      def find_length_validator
        find_validator(ActiveModel::Validations::LengthValidator)
      end

      def has_tokenizer?(length_validator)
        tokenizer = length_validator.options[:tokenizer]

        # TODO: Remove this check when we drop Rails 3.0 support
        if ActiveModel::Validations::LengthValidator.const_defined?(:DEFAULT_TOKENIZER)
          tokenizer && tokenizer != ActiveModel::Validations::LengthValidator::DEFAULT_TOKENIZER
        else
          tokenizer
        end
      end
    end
  end
end
