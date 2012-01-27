module SimpleForm
  module Inputs
    class CollectionCheckBoxesInput < CollectionRadioInput
      protected

      # Checkbox components do not use the required html tag.
      # More info: https://github.com/plataformatec/simple_form/issues/340#issuecomment-2871956
      def has_required?
        false
      end

      def collection_block_for_nested_boolean_style
        return unless nested_boolean_style?

        proc do |label_for, text, value, html_options|
          @builder.check_box(attribute_name, html_options, value, nil) + text
        end
      end

      def item_wrapper_class
        "checkbox"
      end
    end
  end
end
