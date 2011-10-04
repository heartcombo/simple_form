module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input
        (options[:label] == false ? "" : label) + input
      end
    end
  end
end
