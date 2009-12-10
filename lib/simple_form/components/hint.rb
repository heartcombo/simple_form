module SimpleForm
  module Components
    # Basic hint component, which verifies whether a user has defined a hint
    # either on the input or through i18n lookup. If no hint is found, the
    # component is skipped.
    class Hint < Base
      def valid?
        !hidden_input? && !hint.blank?
      end

      def hint
        @hint ||= options[:hint] || translate
      end

      def content
        component_tag hint
      end
    end
  end
end
