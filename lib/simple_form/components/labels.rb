module SimpleForm
  module Components
    module Labels
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods #:nodoc:
        def translate_required_html
          i18n_cache :translate_required_html do
            I18n.t(:"simple_form.required.html", :default =>
              %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr>]
            )
          end
        end

        def translate_required_text
          I18n.t(:"simple_form.required.text", :default => 'required')
        end

        def translate_required_mark
          I18n.t(:"simple_form.required.mark", :default => '*')
        end
      end

      def label
        @builder.label(label_target, label_text, label_html_options)
      end

      def label_text
        result = SimpleForm.label_text.call(raw_label_text, required_label_text)
        result.respond_to?(:html_safe) ? result.html_safe : result
      end

      def label_target
        attribute_name
      end

      def label_html_options
        label_options = html_options_for(:label, input_type, required_class)
        label_options[:for] = options[:input_html][:id] if options.key?(:input_html)
        label_options
      end

    protected

      def raw_label_text #:nodoc:
        options[:label] || label_translation
      end

      # Default required text when attribute is required.
      def required_label_text #:nodoc:
        attribute_required? ? self.class.translate_required_html.dup : ''
      end

      # First check human attribute name and then labels.
      # TODO Remove me in Rails > 2.3.5
      def label_translation #:nodoc:
        default = if object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(reflection_or_attribute_name.to_s)
        else
          attribute_name.to_s.humanize
        end

        translate(:labels, default)
      end
    end
  end
end