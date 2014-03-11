module SimpleForm
  module Inputs
    class CollectionSelectInput < CollectionInput
      def input(context=nil)
        label_method, value_method = detect_collection_methods

        if context
          merged_input_options = merged_input_options(context.options)
        else
          merged_input_options = input_html_options
        end

        @builder.collection_select(
          attribute_name, collection, value_method, label_method,
          input_options, merged_input_options
        )
      end
    end
  end
end
