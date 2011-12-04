module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Hints
      def hint
        if options[:hint] == true
          translate(:hints).presence
        else
          options[:hint]
        end
      end
    end
  end
end
