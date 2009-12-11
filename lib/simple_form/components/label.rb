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

      def self.translate_required_html
        i18n_cache :translate_required_html do
          I18n.t(:"simple_form.required.html", :default =>
            %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr>]
          )
        end
      end

      def self.translate_required_text
        I18n.t(:"simple_form.required.text", :default => 'required')
      end

      def self.translate_required_mark
        I18n.t(:"simple_form.required.mark", :default => '*')
      end

      def valid?
        !hidden_input?
      end

      # Overwrite html for option if the user has changed input id, so the label
      # will always point correctly to the input. Renders a default label.
      def content
        html_options = component_html_options
        html_options[:for] = options[:input_html][:id] if options.key?(:input_html)
        @builder.label(attribute_name, text, html_options)
      end

      # Map attribute to specific name when dealing with date/time/timestamp,
      # ensuring label will always be "clickable". For better accessibility.
      def attribute_name
        case input_type
          when :date, :datetime
            "#{attribute}_1i"
          when :time
            "#{attribute}_4i"
          else
            attribute
        end
      end

      # The method that actually generates the label. This can be overwriten using
      # a SimpleForm configuration value:
      #
      #   SimpleForm.label_text = lambda do |label_text, required_text|
      #     required_text + label_text + ":"
      #   end
      def text
        SimpleForm.label_text.call(label_text, required_text)
      end

      # The user is able to pass a label with the :label option, or it will
      # fallback to label lookup.
      def label_text
        options[:label] || translate_label
      end

      # Default required text when attribute is required.
      def required_text
        attribute_required? ? self.class.translate_required_html.dup : ''
      end

      # Attempts to translate the label using default i18n lookup. If no
      # translation is found, fallback to human_attribute_name if it is
      # available or just use the attribute itself humanized.
      def translate_label
        default = if object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(reflecion_name_or_attribute.to_s)
        else
          attribute.to_s.humanize
        end

        translate(default)
      end
    end
  end
end
