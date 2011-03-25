module SimpleForm
  module Components
    module LabelInput
      def self.included(base)
        base.send :include, SimpleForm::Components::Labels
      end

      def label_input
        the_label = (options[:label] == false ? '' : label)
        if SimpleForm.input_wrapper_tag.nil?
          the_label + input
        else
          the_label + template.content_tag(SimpleForm.input_wrapper_tag, input, :class => SimpleForm.input_wrapper_class)
        end
      end
      
    end
  end
end