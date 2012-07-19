module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Hints
      def hint
        @hint ||= begin
          hint = options[:hint]
          hint_content = hint.is_a?(String) ? hint : translate(:hints)
          hint_content.html_safe if hint_content && hint_content.is_a?(String)
        end
      end

      def has_hint?
        hint.present?
      end
    end
  end
end
