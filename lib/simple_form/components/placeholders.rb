module SimpleForm
  module Components
    module Placeholders
      def placeholder
        disabled_placeholder
      end

      private

      def enabled_placeholder
        input_html_options[:placeholder] ||= placeholder_text if placeholder_present?
        nil
      end

      def disabled_placeholder
        nil
      end

      def placeholder_present?
        options[:placeholder] != false && placeholder_text.present?
      end

      def placeholder_text
        @placeholder_text ||= options[:placeholder] || translate(:placeholders)
      end
    end
  end
end