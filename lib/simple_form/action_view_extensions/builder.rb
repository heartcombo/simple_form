module SimpleForm
  module ActionViewExtensions
    # A collection of methods required by simple_form but added to rails default form.
    # This means that you can use such methods outside simple_form context.
    module Builder

      # Create a collection of radio inputs for the attribute. Basically this
      # helper will create a radio input associated with a label for each
      # text/value option in the collection, using value_method and text_method
      # to convert these text/value. Based on collection_select.
      # Example:
      #
      #   form_for @user do |f|
      #     f.collection_radio :active, [['Yes', true] ,['No', false]], :first, :last
      #   end
      #
      #   <input id="user_active_true" name="user[active]" type="radio" value="true" />
      #   <label class="radio" for="user_active_true">Yes</label>
      #   <input id="user_active_false" name="user[active]" type="radio" value="false" />
      #   <label class="radio" for="user_active_false">No</label>
      #
      def collection_radio(attribute, collection, value_method, text_method, html_options={})
        collection.inject('') do |result, item|
          value = item.send value_method
          text  = item.send text_method

          result << radio_button(attribute, value, html_options) <<
                    label("#{attribute}_#{value}", text, :class => "collection_radio")
        end
      end

      # Wrapper for using simple form inside a default rails form.
      # Example:
      #
      #   form_for @user do |f|
      #     f.simple_fields_for :posts do |posts_form|
      #       # Here you have all simple_form methods available
      #       posts_form.input :title
      #     end
      #   end
      def simple_fields_for(*args, &block)
        options = args.extract_options!
        options[:builder] = SimpleForm::FormBuilder
        fields_for(*(args << options), &block)
      end
    end
  end
end

ActionView::Helpers::FormBuilder.send :include, SimpleForm::ActionViewExtensions::Builder
