module SimpleForm
  module Components
    module LabelInput
      def self.included(base)
        base.send :include, SimpleForm::Components::Labels
      end

      def label_input
        (options[:label] == false ? "" : label) + tag('br') + input
      end
    end
  end
end