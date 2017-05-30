module SimpleForm
  module Inputs
    class EnumInput < CollectionSelectInput
      def input
        object = object_name.classify.constantize

        collection = object.send(attribute_name.to_s.pluralize)
        collection = map_collection(collection, attribute_name)

        label_method, value_method = detect_collection_methods

        @builder.collection_select(attribute_name, collection, value_method,
                             label_method, input_options, input_html_options)
      end

      # Don't touch the collection by default
      def map_collection(collection, attribute_name)
        return collection
      end
    end
  end
end
