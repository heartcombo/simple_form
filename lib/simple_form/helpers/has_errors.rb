module SimpleForm
  module Helpers
    module HasErrors
      private

      def errors
        object.errors
      end

      def has_errors?
        object && object.respond_to?(:errors) && errors.present?
      end
    end
  end
end
