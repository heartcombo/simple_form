module SimpleForm
  module Helpers
    # Helper methods for maxlength.
    module Maxlength #:nodoc:

      private

      def add_maxlength!
        input_html_options[:maxlength] ||= maximum_length_from_validation || limit if SimpleForm.html5
      end

      def maximum_length_from_validation
        return unless has_validators?

        length_validator = find_length_validator or return
        length_validator.options[:maximum]
      end

      def find_length_validator
        find_validator(ActiveModel::Validations::LengthValidator)
      end
    end
  end
end
