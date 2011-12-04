module SimpleForm
  module Components
    module Disabled
      def disabled
        if has_disabled?
          input_html_classes << 'disabled' 
          input_html_options[:disabled] = true
        end
        nil
      end

      def has_disabled?
        options[:disabled] == true
      end

      private

      alias :enabled_disabled :disabled

      def disabled_disabled
        nil
      end
    end
  end
end