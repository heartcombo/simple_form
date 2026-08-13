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
        if_condition = validator.options[:if]
        unless_condition = validator.options[:unless]

        return false if if_condition.nil? && unless_condition.nil?

        conditional = false

        if if_condition
          conditions = Array(if_condition)
          conditional = conditions.any? { |c| !resolve_if_condition(c) }
        end

        if !conditional && unless_condition
          conditions = Array(unless_condition)
          conditional = conditions.any? { |c| resolve_if_condition(c) }
        end

        conditional
      # If evaluating the condition fails (e.g., the condition references a method
      # the object doesn't have, or a callable with unexpected arity), fall back to
      # treating the validator as conditional and skipping it.
      rescue NoMethodError, ArgumentError
        true
      end

      def resolve_if_condition(condition)
        case condition
        when Symbol
          object.send(condition)
        else
          if condition.respond_to?(:call)
            if condition.is_a?(Proc) && condition.arity == 0
              condition.call
            else
              condition.call(object)
            end
          else
            condition
          end
        end
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
