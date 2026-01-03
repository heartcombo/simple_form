# frozen_string_literal: true
module SimpleForm
  module Helpers
    module Validators
      def has_validators?
        @has_validators ||= attribute_name && object.class.respond_to?(:validators_on)
      end

      private

      def attribute_validators
        object.class.validators_on(attribute_name)
      end

      def reflection_validators
        reflection ? object.class.validators_on(reflection.name) : []
      end

      def valid_validator?(validator)
        !conditional_validators?(validator) && action_validator_match?(validator)
      end

      def conditional_validators?(validator)
        validator.options.include?(:if) || validator.options.include?(:unless)
      end

      def action_validator_match?(validator)
        return true unless validator.options.include?(:on)

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

      # Implements `ActiveModel::Validations::ResolveValue`, introduced by Rails 7.1.
      # https://github.com/rails/rails/blob/v7.1.0/activemodel/lib/active_model/validations/resolve_value.rb
      def resolve_validator_value(value)
        case value
        when Proc
          if value.arity == 0
            value.call
          else
            value.call(object)
          end
        when Symbol
          object.send(value)
        else
          if value.respond_to?(:call)
            value.call(object)
          else
            value
          end
        end
      end
    end
  end
end
