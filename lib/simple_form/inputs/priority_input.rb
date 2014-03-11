module SimpleForm
  module Inputs
    class PriorityInput < CollectionSelectInput
      def input(context)
        @builder.send(:"#{input_type}_select", attribute_name, input_priority,
                      input_options, merged_input_options(context.options))
      end

      def input_priority
        options[:priority] || SimpleForm.send(:"#{input_type}_priority")
      end

      protected

      def has_required?
        false
      end

      def skip_include_blank?
        super || input_priority.present?
      end
    end
  end
end
