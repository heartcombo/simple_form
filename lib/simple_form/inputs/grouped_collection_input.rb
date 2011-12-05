module SimpleForm
  module Inputs
    class GroupedCollectionInput < CollectionInput
      def input
        group_label_method, label_method, value_method = detect_collection_methods
        @builder.send(:"grouped_collection_#{input_type}", attribute_name, collection,
                      group_method, group_label_method, value_method, label_method,
                      input_options, input_html_options)
      end

      private

      def group_method
        @group_method ||= options.delete(:group_method)
      end

      def detect_collection_methods
        label, value = super
        group_label = options.delete(:group_label_method)

        group_label ||= detect_common_display_methods[:label]

        [group_label, label, value]
      end
    end
  end
end
