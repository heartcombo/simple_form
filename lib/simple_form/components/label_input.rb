module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input
        apply_label_input_options(options)

        options[:label] == false ? input : (label + input)
      end

      private

      # Get the options given to the label_input component and apply to both
      # label and input components.
      def apply_label_input_options(options)
        [:input_html, :label_html].each do |key|
          if options.has_key?(key)
            options[key].merge! options.fetch(:label_input_html, {})
          end
        end
      end
    end
  end
end
