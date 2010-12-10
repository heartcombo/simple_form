module SimpleForm
  module Inputs
    class PriorityInput < CollectionInput
      def input
        @builder.send(:"#{input_type}_select", attribute_name, input_priority,
                      input_options, input_html_options)
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
