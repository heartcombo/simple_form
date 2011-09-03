module SimpleForm
  module Helpers
    module HasErrors

      def errors
        object.errors
      end

      def has_errors?
        object && object.respond_to?(:errors) && errors.present?
      end
    end
  end
end
