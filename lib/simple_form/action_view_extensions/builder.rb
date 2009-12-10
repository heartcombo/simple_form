module SimpleForm
  module ActionViewExtensions
    # A collection of methods required by simple_form but added to rails default form.
    # This means that you can use such methods outside simple_form context.
    module Builder
      def collection_radio(attribute, collection, value_method, text_method, html_options={})
        collection.inject('') do |result, item|
          value = item.send value_method
          text  = item.send text_method

          result << radio_button(attribute, value, html_options) <<
                    label("#{attribute}_#{value}", text, :class => "radio")
        end
      end

      def simple_fields_for(*args, &block)
        options = args.extract_options!
        options[:builder] = SimpleForm::FormBuilder
        fields_for(*(args << options), &block)
      end
    end
  end
end

ActionView::Helpers::FormBuilder.send :include, SimpleForm::ActionViewExtensions::Builder
