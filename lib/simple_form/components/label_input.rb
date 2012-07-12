module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input
        input_html_options.merge! options.fetch(:label_input_html, {})
        label_html_options.merge! options.fetch(:label_input_html, {})
        options[:label] == false ? input : (label + input)
      end
    end
  end
end
