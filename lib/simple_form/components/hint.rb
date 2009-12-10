module SimpleForm
  module Components
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
