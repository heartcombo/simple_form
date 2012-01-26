module SimpleForm
  module Inputs
    class CollectionRadioInput < CollectionInput
      def input
        label_method, value_method = detect_collection_methods

        @builder.collection_radio(
          attribute_name, collection, value_method, label_method,
          input_options, input_html_options, &collection_block_for_nested_boolean_style
        )
      end

      def input_options
        options = super
        apply_default_collection_options!(options)
        options
      end

      private

      def collection_block_for_nested_boolean_style
        return unless nested_boolean_style?

        proc do |label_for, text, value, html_options|
          @builder.label(label_for, text) { @builder.radio_button(attribute_name, value, html_options) }
        end
      end
    end
  end
end
