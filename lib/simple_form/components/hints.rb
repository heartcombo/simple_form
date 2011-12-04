module SimpleForm
  module Components
    module Hints
      def hint
        (options.delete(:hint) || translate(:hints)).presence
      end
    end
  end
end
