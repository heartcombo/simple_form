module SimpleForm
  module Inputs
    class CollectionSelectInput < CollectionInput
      def input(context=nil)
        label_method, value_method = detect_collection_methods

        merged_input_options = merge_wrapper_options(input_html_options, context)

        @builder.collection_select(
          attribute_name, collection, value_method, label_method,
          input_options, merged_input_options
        )
      end
    end
  end
end
