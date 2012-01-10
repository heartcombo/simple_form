module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Hints
      def hint
        @hint ||= if options[:hint] == true
          translate(:hints)
        else
          options[:hint]
        end
      end

      def has_hint?
        hint.present?
      end
    end
  end
end
