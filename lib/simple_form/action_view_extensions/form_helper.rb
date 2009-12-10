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
          def simple_#{helper}(record_or_name_or_array, *args, &block)
            options = args.extract_options!
            options[:builder] = SimpleForm::FormBuilder
            css_class = case record_or_name_or_array
              when String, Symbol then record_or_name_or_array.to_s
              when Array then dom_class(record_or_name_or_array.last)
              else dom_class(record_or_name_or_array)
            end
            options[:html] ||= {}
            options[:html][:class] = "simple_form \#{css_class} \#{options[:html][:class]}".strip
            #{helper}(record_or_name_or_array, *(args << options), &block)
          end
        METHOD
      end
    end
  end
end

ActionView::Base.send :include, SimpleForm::ActionViewExtensions::FormHelper
