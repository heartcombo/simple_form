module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Minlength
      def minlength
        input_html_options[:'minlength'] ||= minimum_length_from_validation || 0
        nil
      end

      private

      def minimum_length_from_validation
        minlength = options[:minlength]
        if minlength.is_a?(String) || minlength.is_a?(Integer)
          minlength
        else
          length_validator = find_length_validator

          if length_validator && !has_tokenizer?(length_validator)
            length_validator.options[:is] || length_validator.options[:minimum]
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
