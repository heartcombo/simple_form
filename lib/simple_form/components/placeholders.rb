module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Placeholders
      def placeholder
        input_html_options[:placeholder] ||= placeholder_text
        nil
      end

      def placeholder_text
        placeholder = options[:placeholder]
        placeholder.is_a?(String) ? placeholder : translate(:placeholders)
      end
    end
  end
end
