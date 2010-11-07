module SimpleForm
  module Components
    module Placeholders
      def placeholder
        input_html_options[:placeholder] ||= placeholder_text if has_placeholder?
        nil
      end

      def has_placeholder?
        false
      end

      def placeholder_present?
        options[:placeholder] != false && placeholder_text.present?
      end

      def placeholder_text
        @placeholder ||= options[:placeholder] || translate(:placeholders)
      end
    end
  end
end