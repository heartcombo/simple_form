module SimpleForm
  module Components
    module LabelInput
      DEPRECATION_WARN = <<-WARN
%{name} method now accepts a `context` argument. The method definition without the argument is deprecated and will be removed in the next Simple Form version. Change your code from:

    def %{name}

to

    def %{name}(context)
      WARN

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
          ActiveSupport::Deprecation.warn(DEPRECATION_WARN % { name: 'input' })

          method.call
        else
          method.call(context)
        end
      end

      def deprecated_label(context)
        method = method(:label)

        if method.arity == 0
          ActiveSupport::Deprecation.warn(DEPRECATION_WARN % { name: 'label' })

          method.call
        else
          method.call(context)
        end
      end
    end
  end
end
