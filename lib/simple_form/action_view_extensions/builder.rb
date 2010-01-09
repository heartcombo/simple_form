module SimpleForm
  module ActionViewExtensions
    # A collection of methods required by simple_form but added to rails default form.
    # This means that you can use such methods outside simple_form context.
    module Builder

      # Create a collection of radio inputs for the attribute. Basically this
      # helper will create a radio input associated with a label for each
      # text/value option in the collection, using value_method and text_method
      # to convert these text/value. Based on collection_select.
      #
      # == Examples
      #
      #   form_for @user do |f|
      #     f.collection_radio :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
      #   end
      #
      #   <input id="user_options_true" name="user[options]" type="radio" value="true" />
      #   <label class="collection_radio" for="user_options_true">Yes</label>
      #   <input id="user_options_false" name="user[options]" type="radio" value="false" />
      #   <label class="collection_radio" for="user_options_false">No</label>
      #
      # == Options
      #
      # Collection radio accepts some extra options:
      #
      #   * checked  => the value that should be checked initially.
      #
      #   * disabled => the value or values that should be disabled. Accepts a single
      #                 item or an array of items.
      #
      def collection_radio(attribute, collection, value_method, text_method, options={}, html_options={})
        collection.inject('') do |result, item|
          value = item.send value_method
          text  = item.send text_method

          default_html_options = default_html_options_for_collection(item, value, options, html_options)

          result << radio_button(attribute, value, default_html_options) <<
                    label("#{attribute}_#{value}", text, :class => "collection_radio")
        end
      end

      # Creates a collection of check boxes for each item in the collection, associated
      # with a clickable label. Use value_method and text_method to convert items in
      # the collection for use as text/value in check boxes.
      #
      # == Examples
      #
      #   form_for @user do |f|
      #     f.collection_check_box :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
      #   end
      #
      #   <input name="user[options][]" type="hidden" value="" />
      #   <input id="user_options_true" name="user[options][]" type="checkbox" value="true" />
      #   <label class="collection_check_box" for="user_options_true">Yes</label>
      #   <input name="user[options][]" type="hidden" value="" />
      #   <input id="user_options_false" name="user[options][]" type="checkbox" value="false" />
      #   <label class="collection_check_box" for="user_options_false">No</label>
      #
      # == Options
      #
      # Collection check box accepts some extra options:
      #
      #   * checked  => the value or values that should be checked initially. Accepts
      #                 a single item or an array of items.
      #
      #   * disabled => the value or values that should be disabled. Accepts a single
      #                 item or an array of items.
      #
      def collection_check_boxes(attribute, collection, value_method, text_method, options={}, html_options={})
        collection.inject('') do |result, item|
          value = item.send value_method
          text  = item.send text_method

          default_html_options = default_html_options_for_collection(item, value, options, html_options)
          default_html_options[:multiple] = true

          result << check_box(attribute, default_html_options, value, '') <<
                    label("#{attribute}_#{value}", text, :class => "collection_check_boxes")
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

      private

        # Generate default options for collection helpers, such as :checked and
        # :disabled.
        def default_html_options_for_collection(item, value, options, html_options) #:nodoc:
          returning(html_options.dup) do |default_html_options|
            [:checked, :disabled].each do |option|
              next unless options[option]

              accept = if options[option].is_a?(Proc)
                options[option].call(item)
              else
                Array(options[option]).include?(value)
              end

              default_html_options[option] = true if accept
            end
          end
        end
    end
  end
end

ActionView::Helpers::FormBuilder.send :include, SimpleForm::ActionViewExtensions::Builder
