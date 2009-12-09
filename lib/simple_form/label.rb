module SimpleForm
  module Label

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        @translate_required_string = {}
      end
    end

    module ClassMethods
      def translate_required_string
        @translate_required_string[I18n.locale] ||= I18n.t(:"simple_form.required.string", :default =>
          %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr> ]
        )
      end

      def translate_required_text
        I18n.t(:"simple_form.required.text", :default => 'required')
      end

      def translate_required_mark
        I18n.t(:"simple_form.required.mark", :default => '*')
      end
    end

    private

      def generate_label
        return '' if skip_label?
        html_options = { :class => default_css_classes }
        html_options[:for] = @options[:html][:id] if @options.key?(:html)
        label(@attribute, label_text, html_options)
      end

      def skip_label?
        @options[:label] == false || hidden_input?
      end

      def label_text
        required_text << (@options[:label] || translate_label)
      end

      def required_text
        attribute_required? ? self.class.translate_required_string : ''
      end

      def translate_label
        default = @object.try(:human_attribute_name, @attribute.to_s) || @attribute.to_s.humanize
        translate_form(:labels, default)
      end

  end
end
