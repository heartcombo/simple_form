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
        # options[:hint_html_safe] is true OR (options[:hint_html_safe] was not defined AND SimpleForm.hint_html_safe is true)
        if options[:hint_html_safe] || (options[:hint_html_safe].nil? && SimpleForm.hint_html_safe)
          @hint_text.try(:html_safe)
        else
          @hint_text
        end
      end

      def hint_html_options
        html_options_for(:hint, [SimpleForm.hint_class])
      end
    end
  end
end
