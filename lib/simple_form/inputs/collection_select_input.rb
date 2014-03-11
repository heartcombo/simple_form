module SimpleForm
  module Inputs
    class CollectionSelectInput < CollectionInput
      def input(context)
        label_method, value_method = detect_collection_methods

        @builder.collection_select(
          attribute_name, collection, value_method, label_method,
          input_options, merged_input_options(context.options)
        )
      end
    end
  end
end
