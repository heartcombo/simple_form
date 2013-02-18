module SimpleForm
  module Helpers
    module Validators
      def has_validators?
        @has_validators ||= attribute_name && object.respond_to?(:_validators)
      end

      private

      def attribute_validators
        object._validators[attribute_name]
      end

      def reflection_validators
        reflection ? object._validators[reflection.name] : []
      end

      def valid_validator?(validator)
        !conditional_validators?(validator) && action_validator_match?(validator)
      end

      def conditional_validators?(validator)
        validator.options.include?(:if) || validator.options.include?(:unless)
      end

      def action_validator_match?(validator)
        return true if !validator.options.include?(:on)

        case validator.options[:on]
        when :save
          true
        when :create
          !object.persisted?
        when :update
          object.persisted?
        end
      end

      def find_validator(kind)
        attribute_validators.find { |v| v.kind == kind } if has_validators?
      end
    end
  end
end
