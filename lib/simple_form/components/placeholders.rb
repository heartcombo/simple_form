module SimpleForm
  module Components
    module Placeholders
      def placeholder
        nil # This component is disabled by default.
      end

      def has_placeholder?
        options[:placeholder] != false && placeholder_text.present?
      end

      private

      def enabled_placeholder
        input_html_options[:placeholder] ||= placeholder_text if has_placeholder?
        nil
      end

      def disabled_placeholder
        nil
      end

      def placeholder_text
        @placeholder_text ||= options[:placeholder] || translate(:placeholders)
      end
    end
  end
end