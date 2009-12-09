module SimpleForm
  # A collection of methods required by simple_form but added to rails default form.
  # This means that you can use such methods outside simple_form context.
  module BuilderExtensions
    def collection_radio(attribute, collection, value_method, text_method, html_options={})
      collection.inject('') do |result, item|
        value = item.send value_method
        text  = item.send text_method

        result << radio_button(attribute, value, html_options) <<
                  label("#{attribute}_#{value}", text, :class => "radio")
      end
    end
  end
end