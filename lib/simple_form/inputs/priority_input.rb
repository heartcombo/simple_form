module SimpleForm
  module Inputs
    class PriorityInput < Base
      def input
        @builder.send(:"#{input_type}_select", attribute_name, input_priority,
                      input_options, input_html_options)
      end

      def input_priority
        options[:priority] || SimpleForm.send(:"#{input_type}_priority")
      end
    end
  end
end