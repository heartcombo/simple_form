module SimpleForm
  module Label

    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end

    module ClassMethods #:nodoc:
      def translate_required_string
        i18n_cache :translate_required_string do
          I18n.t(:"simple_form.required.string", :default =>
            %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr> ]
          )
        end
      end

      def translate_required_text
        i18n_cache :translate_required_text do
          I18n.t(:"simple_form.required.text", :default => 'required')
        end
      end

      def translate_required_mark
        i18n_cache :translate_required_mark do
          I18n.t(:"simple_form.required.mark", :default => '*')
        end
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
        attribute_required? ? self.class.translate_required_string.dup : ''
      end

      def translate_label
        default = @object.try(:human_attribute_name, @attribute.to_s) || @attribute.to_s.humanize
        translate_form(:labels, default)
      end

  end
end
