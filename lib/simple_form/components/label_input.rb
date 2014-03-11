module SimpleForm
  module Components
    module LabelInput
      extend ActiveSupport::Concern

      included do
        include SimpleForm::Components::Labels
      end

      def label_input(context = nil)
        if options[:label] == false
          deprecated_component(:input, context)
        else
          deprecated_component(:label, context) + deprecated_component(:input, context)
        end
      end

      private

      def deprecated_component(namespace, context)
        method = method(namespace)

        if method.arity == 0
          ActiveSupport::Deprecation.warn(SimpleForm::CUSTOM_INPUT_DEPRECATION_WARN % { name: namespace })

          method.call
        else
          method.call(context)
        end
      end
    end
  end
end
