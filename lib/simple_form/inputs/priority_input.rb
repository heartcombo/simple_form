module SimpleForm
  module Inputs
    class PriorityInput < CollectionSelectInput
      def input(context=nil)
        if context
          merged_input_options = merge_wrapper_options(input_html_options, context.options)
        else
          merged_input_options = input_html_options
        end

        @builder.send(:"#{input_type}_select", attribute_name, input_priority,
                      input_options, merged_input_options)
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
