module SimpleForm
  module ActionViewExtensions
    module FormHelper
      def simple_form_for(*args, &block)
        build_simple_form(:form_for, *args, &block)
      end

      def simple_fields_for(*args, &block)
        build_simple_form(:fields_for, *args, &block)
      end

      def simple_remote_form_for(*args, &block)
        build_simple_form(:remote_form_for, *args, &block)
      end

      private

        def build_simple_form(form_method, *args, &block)
          options = args.extract_options!
          options[:builder] = SimpleForm::FormBuilder
          send(form_method, *(args << options), &block)
        end
    end
  end
end

ActionView::Base.send :include, SimpleForm::ActionViewExtensions::FormHelper
