module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Hints
      def hint
        @hint ||= begin
          hint = options[:hint]
          hint.is_a?(String) ? hint : translate(:hints)
        end
      end

      def has_hint?
        hint.present?
      end
    end
  end
end
