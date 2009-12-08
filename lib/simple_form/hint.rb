module SimpleForm
  module Hint

    private

      def generate_hint
        return '' unless @options.key?(:hint)
        @template.content_tag(:span, @options[:hint], :class => 'hint')
      end
  end
end
