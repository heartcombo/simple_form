module SimpleForm
  module Inputs
    class RangeInput < NumericInput
      disable :placeholder

      def input
        if SimpleForm.html5
          input_html_options[:type] ||= "range"
          input_html_options[:step] ||= 1
        end

        super
      end
    end
  end
end
