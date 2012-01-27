module SimpleForm
  module Inputs
    class CollectionRadioInput < CollectionInput
      def input
        label_method, value_method = detect_collection_methods

        @builder.send("collection_#{input_type}",
          attribute_name, collection, value_method, label_method,
          input_options, input_html_options, &collection_block_for_nested_boolean_style
        )
      end

      def input_options
        options = super
        apply_default_collection_options!(options)
        options
      end

      protected

      def apply_default_collection_options!(options)
        unless options.key?(:item_wrapper_tag)
          options[:item_wrapper_tag] = SimpleForm.item_wrapper_tag
        end
        unless options.key?(:collection_wrapper_tag)
          options[:collection_wrapper_tag] = SimpleForm.collection_wrapper_tag
        end
        options[:collection_wrapper_class] = [
          options[:collection_wrapper_class], SimpleForm.collection_wrapper_class
        ].compact.presence
      end

      def collection_block_for_nested_boolean_style
        return unless nested_boolean_style?

        proc do |label_for, text, value, html_options|
          @builder.label(label_for) { nested_boolean_style_item_tag(value, html_options) + text }
        end
      end

      def nested_boolean_style_item_tag(value, html_options)
        @builder.radio_button(attribute_name, value, html_options)
      end

      # Do not attempt to generate label[for] attributes by default, unless an
      # explicit html option is given. This avoids generating labels pointing to
      # non existent fields.
      def generate_label_for_attribute?
        false
      end
    end
  end
end
