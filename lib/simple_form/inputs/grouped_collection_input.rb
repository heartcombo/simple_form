module SimpleForm
  module Inputs
    class GroupedCollectionInput < CollectionInput
      def input
        label_method, value_method = detect_collection_methods
        @builder.grouped_collection_select(attribute_name, group_collection,
                      group_method, group_label_method, value_method, label_method,
                      input_options, input_html_options)
      end

      private

      def group_collection
        @group_collection ||= options.delete(:collection)
      end

      # Sample collection
      def collection
        @collection ||= group_collection.first.try(:send, group_method)
      end

      def group_method
        @group_method ||= options.delete(:group_method)
      end

      def group_label_method
        label = options.delete(:group_label_method)

        unless label
          common_method_for = detect_common_display_methods( detect_collection_classes(group_collection) )
          label = common_method_for[:label]
        end

        label
      end
    end
  end
end
