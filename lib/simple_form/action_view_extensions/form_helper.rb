module SimpleForm
  module ActionViewExtensions
    module FormHelper
      def simple_form_for(*args, &block)
        options = args.extract_options!
        options[:builder] = SimpleForm::FormBuilder
        form_for(*(args << options), &block)
      end
    end
  end
end

ActionView::Base.send :include, SimpleForm::ActionViewExtensions::FormHelper