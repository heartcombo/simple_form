module SimpleForm
  module Components
    module Placeholders
      def placeholder
        input_html_options[:placeholder] ||= placeholder_text if has_placeholder?
        nil
      end

      def has_placeholder?
        placeholder_text.present?
      end

      private

      def placeholder_text
        @placeholder_text ||= options[:placeholder] || translate(:placeholders)
      end
    end
  end
end