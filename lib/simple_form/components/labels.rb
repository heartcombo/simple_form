module SimpleForm
  module Components
    module Labels
      extend ActiveSupport::Concern

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
        enabled_label
      end

      def label_text
        SimpleForm.label_text.call(raw_label_text, required_label_text).html_safe
      end

      def label_target
        attribute_name
      end

      def label_html_options
        label_options = html_options_for(:label, [input_type, required_class, SimpleForm.label_class])
        label_options[:for] = options[:input_html][:id] if options.key?(:input_html) && options[:input_html].key?(:id)
        label_options
      end

    protected

      def enabled_label
        @builder.label(label_target, label_text, label_html_options)
      end

      def disabled_label
        ""
      end

      def raw_label_text #:nodoc:
        options[:label] || label_translation
      end

      # Default required text when attribute is required.
      def required_label_text #:nodoc:
        attribute_required? ? self.class.translate_required_html.dup : ''
      end

      # First check labels translation and then human attribute name.
      def label_translation #:nodoc:
        translate(:labels) || if object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(reflection_or_attribute_name.to_s)
        else
          attribute_name.to_s.humanize
        end
      end
    end
  end
end
