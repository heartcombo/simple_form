module SimpleForm
  module Components
    module Hints
      def hint
        enabled_hint
      end

      private

      def enabled_hint
        (options.delete(:hint) || translate(:hints)).presence
      end

      def disabled_hint
        nil
      end
    end
  end
end
