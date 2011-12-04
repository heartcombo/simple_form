module SimpleForm
  module Components
    module Hints
      def hint
        (options.delete(:hint) || translate(:hints)).presence if has_hint?
      end

      private

      def has_hint?
        true
      end
    end
  end
end
