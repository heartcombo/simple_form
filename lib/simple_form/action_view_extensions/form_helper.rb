module SimpleForm
  module ActionViewExtensions
    # This modules create simple form wrappers around default form_for,
    # fields_for and remote_form_for.
    #
    # Example:
    #
    #   simple_form_for @user do |f|
    #     f.input :name, :hint => 'My hint'
    #   end
    #
    module FormHelper
      [:form_for, :fields_for, :remote_form_for].each do |helper|
        class_eval <<-METHOD, __FILE__, __LINE__
          def simple_#{helper}(*args, &block)
            options = args.extract_options!
            options[:builder] = SimpleForm::FormBuilder
            #{helper}(*(args << options), &block)
          end
        METHOD
      end
    end
  end
end

ActionView::Base.send :include, SimpleForm::ActionViewExtensions::FormHelper
