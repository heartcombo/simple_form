module SimpleForm
  module ActionViewExtensions
    # A collection of methods required by simple_form but added to rails default form.
    # This means that you can use such methods outside simple_form context.
    module Builder

      # Create a collection of radio inputs for the attribute. Basically this
      # helper will create a radio input associated with a label for each
      # text/value option in the collection, using value_method and text_method
      # to convert these text/value. You can give a symbol or a proc to both
      # value_method and text_method, that will be evaluated for each item in
      # the collection.
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
      #   * collection_wrapper_tag => the tag to wrap the entire collection.
      #
      #   * item_wrapper_tag       => the tag to wrap each item in the collection.
      #
      def collection_radio(attribute, collection, value_method, text_method, options={}, html_options={})
        render_collection(
          attribute, collection, value_method, text_method, options, html_options
        ) do |value, text, default_html_options|
          radio_button(attribute, value, default_html_options) +
            label(sanitize_attribute_name(attribute, value), text, :class => "collection_radio")
        end
      end

      # Creates a collection of check boxes for each item in the collection,
      # associated with a clickable label. Use value_method and text_method to
      # convert items in the collection for use as text/value in check boxes.
      # You can give a symbol or a proc to both value_method and text_method,
      # that will be evaluated for each item in the collection.
      #
      # == Examples
      #
      #   form_for @user do |f|
      #     f.collection_check_boxes :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
      #   end
      #
      #   <input name="user[options][]" type="hidden" value="" />
      #   <input id="user_options_true" name="user[options][]" type="checkbox" value="true" />
      #   <label class="collection_check_boxes" for="user_options_true">Yes</label>
      #   <input name="user[options][]" type="hidden" value="" />
      #   <input id="user_options_false" name="user[options][]" type="checkbox" value="false" />
      #   <label class="collection_check_boxes" for="user_options_false">No</label>
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
      #   * collection_wrapper_tag => the tag to wrap the entire collection.
      #
      #   * item_wrapper_tag       => the tag to wrap each item in the collection.
      #
      def collection_check_boxes(attribute, collection, value_method, text_method, options={}, html_options={})
        render_collection(
          attribute, collection, value_method, text_method, options, html_options
        ) do |value, text, default_html_options|
          default_html_options[:multiple] = true

          check_box(attribute, default_html_options, value, '') +
            label(sanitize_attribute_name(attribute, value), text, :class => "collection_check_boxes")
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
        if self.class < ActionView::Helpers::FormBuilder
          options[:builder] ||= self.class
        else
          options[:builder] ||= SimpleForm::FormBuilder
        end
        fields_for(*(args << options), &block)
      end

    private

      # Generate default options for collection helpers, such as :checked and
      # :disabled.
      def default_html_options_for_collection(item, value, options, html_options) #:nodoc:
        html_options = html_options.dup

        [:checked, :selected, :disabled].each do |option|
          next unless options[option]

          accept = if options[option].respond_to?(:call)
            options[option].call(item)
          else
            Array(options[option]).include?(value)
          end

          html_options[option] = true if accept
        end

        html_options
      end

      def sanitize_attribute_name(attribute, value)
        "#{attribute}_#{value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}"
      end

      def render_collection(attribute, collection, value_method, text_method, options={}, html_options={}) #:nodoc:
        collection_wrapper_tag = options.has_key?(:collection_wrapper_tag) ? options[:collection_wrapper_tag] : SimpleForm.collection_wrapper_tag
        item_wrapper_tag = options.has_key?(:item_wrapper_tag) ? options[:item_wrapper_tag] : SimpleForm.item_wrapper_tag

        rendered_collection = collection.map do |item|
          value = value_for_collection(item, value_method)
          text  = value_for_collection(item, text_method)
          default_html_options = default_html_options_for_collection(item, value, options, html_options)

          rendered_item = yield value, text, default_html_options

          item_wrapper_tag ? @template.content_tag(item_wrapper_tag, rendered_item) : rendered_item
        end.join.html_safe

        collection_wrapper_tag ? @template.content_tag(collection_wrapper_tag, rendered_collection) : rendered_collection
      end

      def value_for_collection(item, value) #:nodoc:
        value.respond_to?(:call) ? value.call(item) : item.send(value)
      end
    end
  end
end

class ActionView::Helpers::FormBuilder
  include SimpleForm::ActionViewExtensions::Builder

  # Override default Rails collection_select helper to handle lambdas/procs in
  # text and value methods, so it works the same way as collection_radio and
  # collection_check_boxes in SimpleForm. If none of text/value methods is a
  # callable object, then it just delegates back to original collection select.
  #
  alias :original_collection_select :collection_select
  def collection_select(attribute, collection, value_method, text_method, options={}, html_options={})
    if value_method.respond_to?(:call) || text_method.respond_to?(:call)
      collection = collection.map do |item|
        value = value_for_collection(item, value_method)
        text  = value_for_collection(item, text_method)

        default_html_options = default_html_options_for_collection(item, value, options, html_options)
        disabled = value if default_html_options[:disabled]
        selected = value if default_html_options[:selected]

        [value, text, selected, disabled]
      end

      [:disabled, :selected].each do |option|
        option_value    = collection.map(&:pop).compact
        options[option] = option_value if option_value.present?
      end
      value_method, text_method = :first, :last
    end

    original_collection_select(attribute, collection, value_method, text_method, options, html_options)
  end
end
