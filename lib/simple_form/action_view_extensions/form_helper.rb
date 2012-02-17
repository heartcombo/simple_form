module SimpleForm
  module ActionViewExtensions
    # This module creates SimpleForm wrappers around default form_for and fields_for.
    #
    # Example:
    #
    #   simple_form_for @user do |f|
    #     f.input :name, :hint => 'My hint'
    #   end
    #
    module FormHelper
      # based on what is done in formtastic
      # http://github.com/justinfrench/formtastic/blob/master/lib/formtastic.rb#L1706
      @@default_field_error_proc = nil

      # Override the default ActiveRecordHelper behaviour of wrapping the input.
      # This gets taken care of semantically by adding an error class to the wrapper tag
      # containing the input.
      #
      FIELD_ERROR_PROC = proc do |html_tag, instance_tag|
        html_tag
      end

      def simple_form_for(record, options={}, &block)
        options[:builder] ||= SimpleForm::FormBuilder
        options[:html] ||= {}
        unless options[:html].key?(:novalidate)
          options[:html][:novalidate] = !SimpleForm.browser_validations
        end
        options[:html][:class] = [SimpleForm.form_class, simple_form_css_class(record, options)].compact.join(" ")

        with_simple_form_field_error_proc do
          form_for(record, options, &block)
        end
      end

      def simple_fields_for(record_name, record_object = nil, options = {}, &block)
        options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
        options[:builder] ||= SimpleForm::FormBuilder

        with_simple_form_field_error_proc do
          fields_for(record_name, record_object, options, &block)
        end
      end

      private

      def with_simple_form_field_error_proc
        @@default_field_error_proc = ::ActionView::Base.field_error_proc
        ::ActionView::Base.field_error_proc = FIELD_ERROR_PROC
        result = yield
        ::ActionView::Base.field_error_proc = @@default_field_error_proc
        result
      end

      def simple_form_css_class(record, options)
        html_options = options[:html]
        as = options[:as]

        if html_options.key?(:class)
          html_options[:class]
        elsif record.is_a?(String) || record.is_a?(Symbol)
          as || record
        else
          record = record.last if record.is_a?(Array)
          action = record.respond_to?(:persisted?) && record.persisted? ? :edit : :new
          as ? "#{action}_#{as}" : dom_class(record, action)
        end
      end
    end
  end
end

ActionView::Base.send :include, SimpleForm::ActionViewExtensions::FormHelper
