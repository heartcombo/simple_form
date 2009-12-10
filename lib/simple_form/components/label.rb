module SimpleForm
  module Components
    # Responsible for rendering label with default options, such as required
    # and translation using i18n. By default all fields are required, and label
    # will prepend a default string with a required mark in all labels. You can
    # disable the required option just passing :required => false in your
    # label/input declaration. You can also use i18n to change the required
    # text, mark or entire html string that is generated.
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

      # Overwrite html for option if the user has changed input id, so the label
      # will always point correctly to the input. Renders a default label.
      def content
        html_options = component_html_options
        html_options[:for] = options[:input_html][:id] if options.key?(:input_html)
        @builder.label(attribute, label_text, html_options)
      end

      # Prepends the required text to label if it is required. The user is able
      # to pass a label with the :label option, or it will fallback to label
      # lookup.
      def label_text
        required_text << (options[:label] || translate_label)
      end

      # Default required text when attribute is required.
      def required_text
        attribute_required? ? self.class.translate_required_string.dup : ''
      end

      # Attempts to translate the label using default i18n lookup. If no
      # translation is found, fallback to human_attribute_name if it is
      # available or just use the attribute itself humanized.
      def translate_label
        default = object.try(:human_attribute_name, attribute.to_s) || attribute.to_s.humanize
        translate(default)
      end
    end
  end
end
