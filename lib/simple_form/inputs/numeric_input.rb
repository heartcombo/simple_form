module SimpleForm
  module Inputs
    class NumericInput < Base
      enable :placeholder, :min_max

      def input
        add_size!
        input_html_classes.unshift("numeric")
        if html5?
          input_html_options[:type] ||= "number"
          input_html_options[:step] ||= integer? ? 1 : "any"
        end
        @builder.text_field(attribute_name, input_html_options)
      end

      private

      # Rails adds the size attr by default, if the :size key does not exist.
      def add_size!
        input_html_options[:size] ||= nil
      end
    end
  end
end
