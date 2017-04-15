module SimpleForm
  module Components
    module DefaultInputClass
      extend ActiveSupport::Concern

      def ignore_default_input_class
        options[:ignore_default_input_class] == true
      end
    end
  end
end
