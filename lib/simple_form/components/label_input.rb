module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input(context)
        options[:label] == false ? input(context) : (label(context) + input(context))
      end
    end
  end
end
