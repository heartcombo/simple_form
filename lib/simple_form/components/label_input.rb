module SimpleForm
  module Components
    module LabelInput
      def self.included(base)
        base.send :include, SimpleForm::Components::Labels
        base.send :include, SimpleForm::Components::Errors
      end

      def label_input
        the_label = (options[:label] == false ? '' : label)
        the_input = (options[:components] || SimpleForm.components).include?(:error) && options[:error] && error ? input.safe_concat(error) : input

        if SimpleForm.input_wrapper_tag.nil?
          the_label + the_input
        else
          the_label + template.content_tag(SimpleForm.input_wrapper_tag, the_input , :class => SimpleForm.input_wrapper_class)
        end
      end
    end
  end
end
