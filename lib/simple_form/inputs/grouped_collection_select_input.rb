module SimpleForm
  module Inputs
    class GroupedCollectionSelectInput < CollectionInput
      def input
        label_method, value_method = detect_collection_methods
        @builder.grouped_collection_select(attribute_name, grouped_collection,
                      group_method, group_label_method, value_method, label_method,
                      input_options, input_html_options)
      end

      private

      def grouped_collection
        @grouped_collection ||= begin
          grouped_collection = options.delete(:collection)
          grouped_collection.respond_to?(:call) ? grouped_collection.call : grouped_collection.to_a
        end
      end

      # Sample collection
      def collection
        @collection ||= grouped_collection.first.try(:send, group_method) || []
      end

      def group_method
        @group_method ||= options.delete(:group_method)
      end

      def group_label_method
        label = options.delete(:group_label_method)

        unless label
          common_method_for = detect_common_display_methods(detect_collection_classes(grouped_collection))
          label = common_method_for[:label]
        end

        label
      end
    end
  end
end
