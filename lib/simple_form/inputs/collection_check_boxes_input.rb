module SimpleForm
  module Inputs
    class CollectionCheckBoxesInput < CollectionRadioButtonsInput
      protected

      # Checkbox components do not use the required html tag.
      # More info: https://github.com/plataformatec/simple_form/issues/340#issuecomment-2871956
      def has_required?
        false
      end

      def build_nested_boolean_style_item_tag(text, value, html_options)
        @builder.check_box(attribute_name, html_options, value, nil) + text
      end

      def item_wrapper_class
        "checkbox"
      end
    end
  end
end
