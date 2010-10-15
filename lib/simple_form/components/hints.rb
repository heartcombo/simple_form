module SimpleForm
  module Components
    module Hints
      def hint
        template.content_tag(hint_tag, hint_text, hint_html_options) unless hint_text.blank?
      end

      def hint_tag
        options[:hint_tag] || SimpleForm.hint_tag
      end

      def hint_text
        @hint_text ||= options[:hint] || translate(:hints)
      end

      def hint_html_options
        html_options_for(:hint, [SimpleForm.hint_class])
      end
    end
  end
end
