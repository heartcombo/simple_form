module SimpleForm
  module Hint

    private

      def generate_hint
        return '' if skip_hint? || (text = hint_text).blank?
        @template.content_tag(:span, text, :class => 'hint')
      end

      def skip_hint?
        @options[:hint] == false || hidden_input?
      end

      def hint_text
        @options[:hint] || translate_hint
      end

      def translate_hint
        translate_form(:hints)
      end
  end
end
