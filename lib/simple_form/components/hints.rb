module SimpleForm
  module Components
    module Hints
      def hint
        (options.delete(:hint) || translate(:hints)).presence
      end

      private

      alias :enabled_hint :hint

      def disabled_hint
        nil
      end
    end
  end
end
