module SimpleForm
  module Inputs
    class CollectionCheckBoxesInput < CollectionRadioInput
      protected

      # Checkbox components do not use the required html tag.
      # More info: https://github.com/plataformatec/simple_form/issues/340#issuecomment-2871956
      def has_required?
        false
      end

      def nested_boolean_style_item_tag(value, html_options)
        @builder.check_box(attribute_name, html_options, value)
      end
    end
  end
end
