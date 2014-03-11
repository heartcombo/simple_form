module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input(context=nil)
        options[:label] == false ? deprecated_input(context) : (deprecated_label(context) + deprecated_input(context))
      end

      private

      def deprecated_input(context)
        method = method(:input)

        if method.arity == 0
          ActiveSupport::Deprecation.warn(SimpleForm::CUSTOM_INPUT_DEPRECATION_WARN % { name: 'input' })

          method.call
        else
          method.call(context)
        end
      end

      def deprecated_label(context)
        method = method(:label)

        if method.arity == 0
          ActiveSupport::Deprecation.warn(SimpleForm::CUSTOM_INPUT_DEPRECATION_WARN % { name: 'label' })

          method.call
        else
          method.call(context)
        end
      end
    end
  end
end
