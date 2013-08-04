module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input
        [:input_html, :label_html].each do |key|
          if options.has_key? key
            options[key].merge! options.fetch(:label_input_html, {})
          end
        end
        options[:label] == false ? input : (label + input)
      end
    end
  end
end
