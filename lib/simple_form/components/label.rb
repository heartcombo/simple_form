module SimpleForm
  module Components
    class Label < Base
      include RequiredHelpers
      extend I18nCache

      def self.translate_required_string
        i18n_cache :translate_required_string do
          I18n.t(:"simple_form.required.string", :default =>
            %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr> ]
          )
        end
      end

      def self.translate_required_text
        i18n_cache :translate_required_text do
          I18n.t(:"simple_form.required.text", :default => 'required')
        end
      end

      def self.translate_required_mark
        i18n_cache :translate_required_mark do
          I18n.t(:"simple_form.required.mark", :default => '*')
        end
      end

      def valid?
        !hidden_input?
      end

      def content
        html_options = component_html_options
        html_options[:for] = options[:input_html][:id] if options.key?(:input_html)
        @builder.label(attribute, label_text, html_options)
      end

      def label_text
        required_text << (options[:label] || translate_label)
      end

      def required_text
        attribute_required? ? self.class.translate_required_string.dup : ''
      end

      def translate_label
        default = if object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(attribute.to_s)
        else
          attribute.to_s.humanize
        end

        translate(default)
      end
    end
  end
end
