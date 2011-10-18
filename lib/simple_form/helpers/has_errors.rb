module SimpleForm
  module Helpers
    module HasErrors
      private

      def has_errors?
        object && object.respond_to?(:errors) && object.errors.present?
      end
    end
  end
end
