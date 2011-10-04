module SimpleForm
  module Helpers
    module Disabled
      private

      def disabled_class
        'disabled' if has_disabled?
      end

      def has_disabled?
        options[:disabled] == true
      end
    end
  end
end
