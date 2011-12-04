module SimpleForm
  module Components
    module Placeholders
      def placeholder
        input_html_options[:placeholder] ||= placeholder_text
        nil
      end

      def placeholder_text
        if options[:placeholder] == true
          translate(:placeholders).presence
        else
          options[:placeholder]
        end
      end
    end
  end
end