module SimpleForm
  module Inputs
    class CollectionCheckBoxesInput < CollectionRadioInput
      def input
        label_method, value_method = detect_collection_methods

        @builder.collection_check_boxes(
          attribute_name, collection, value_method, label_method,
          input_options, input_html_options, &collection_block_for_nested_boolean_style
        )
      end

      private

      # Checkbox components does not use the required html tag.
      # See more info here - https://github.com/plataformatec/simple_form/issues/340#issuecomment-2871956
      def has_required?
        false
      end

      def collection_block_for_nested_boolean_style
        return unless nested_boolean_style?

        proc do |label_for, text, value, html_options|
          @builder.label(label_for, text) { @builder.check_box(attribute_name, html_options, value) }
        end
      end
    end
  end
end
