module SimpleForm
  module ActionViewExtensions
    # Base builder to handle each instance of a collection of radio buttons / check boxes.
    # Based on (at this time upcoming) Rails 4 collection builders.
    class BuilderBase #:nodoc:
      attr_reader :object, :text, :value

      def initialize(form_builder, method_name, object, sanitized_attribute_name, text,
                     value, input_html_options)
        @form_builder = form_builder
        @method_name = method_name
        @object = object
        @sanitized_attribute_name = sanitized_attribute_name
        @text = text
        @value = value
        @input_html_options = input_html_options
      end

      def label(label_html_options={}, &block)
        @form_builder.label(@sanitized_attribute_name, @text, label_html_options, &block)
      end
    end

    # Handles generating an instance of radio + label for collection_radio_buttons.
    class RadioButtonBuilder < BuilderBase #:nodoc:
      def radio_button(extra_html_options={})
        html_options = extra_html_options.merge(@input_html_options)
        @form_builder.radio_button(@method_name, @value, html_options)
      end
    end

    # Handles generating an instance of check box + label for collection_check_boxes.
    class CheckBoxBuilder < BuilderBase #:nodoc:
      def check_box(extra_html_options={})
        html_options = extra_html_options.merge(@input_html_options)
        @form_builder.check_box(@method_name, html_options, @value, nil)
      end
    end

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
      #     f.collection_radio_buttons :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
      #   end
      #
      #   <input id="user_options_true" name="user[options]" type="radio" value="true" />
      #   <label class="collection_radio_buttons" for="user_options_true">Yes</label>
      #   <input id="user_options_false" name="user[options]" type="radio" value="false" />
      #   <label class="collection_radio_buttons" for="user_options_false">No</label>
      #
      # It is also possible to give a block that should generate the radio +
      # label. To wrap the radio with the label, for instance:
      #
      #   form_for @user do |f|
      #     f.collection_radio_buttons(
      #       :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
      #     ) do |b|
      #       b.label { b.radio_button + b.text }
      #     end
      #   end
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
      #   * collection_wrapper_tag   => the tag to wrap the entire collection.
      #
      #   * collection_wrapper_class => the CSS class to use for collection_wrapper_tag
      #
      #   * item_wrapper_tag         => the tag to wrap each item in the collection.
      #
      #   * item_wrapper_class       => the CSS class to use for item_wrapper_tag
      #
      #   * a block                  => to generate the label + radio or any other component.
      #
      def collection_radio_buttons(attribute, collection, value_method, text_method, options={}, html_options={})
        rendered_collection = render_collection(
          collection, value_method, text_method, options, html_options
        ) do |item, value, text, default_html_options|
          builder = instantiate_collection_builder(RadioButtonBuilder, attribute, item, value, text, default_html_options)

          if block_given?
            yield builder
          else
            builder.radio_button + builder.label(:class => "collection_radio_buttons")
          end
        end

        wrap_rendered_collection(rendered_collection, options)
      end

      # deprecated
      def collection_radio(*args, &block)
        SimpleForm.deprecation_warn "The `collection_radio` helper is deprecated, " \
          "please use `collection_radio_buttons` instead."
        collection_radio_buttons(*args, &block)
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
      # It is also possible to give a block that should generate the check box +
      # label. To wrap the check box with the label, for instance:
      #
      #   form_for @user do |f|
      #     f.collection_check_boxes(
      #       :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
      #     ) do |b|
      #       b.label { b.check_box + b.text }
      #     end
      #   end
      #
      # == Options
      #
      # Collection check box accepts some extra options:
      #
      #   * checked  => the value or values that should be checked initially. Accepts
      #                 a single item or an array of items. It overrides existing associations.
      #
      #   * disabled => the value or values that should be disabled. Accepts a single
      #                 item or an array of items.
      #
      #   * collection_wrapper_tag   => the tag to wrap the entire collection.
      #
      #   * collection_wrapper_class => the CSS class to use for collection_wrapper_tag. This option
      #                                 is ignored if the :collection_wrapper_tag option is blank.
      #
      #   * item_wrapper_tag         => the tag to wrap each item in the collection.
      #
      #   * item_wrapper_class       => the CSS class to use for item_wrapper_tag
      #
      #   * a block                  => to generate the label + check box or any other component.
      #
      def collection_check_boxes(attribute, collection, value_method, text_method, options={}, html_options={})
        rendered_collection = render_collection(
          collection, value_method, text_method, options, html_options
        ) do |item, value, text, default_html_options|
          default_html_options[:multiple] = true
          builder = instantiate_collection_builder(CheckBoxBuilder, attribute, item, value, text, default_html_options)

          if block_given?
            yield builder
          else
            builder.check_box + builder.label(:class => "collection_check_boxes")
          end
        end

        # Append a hidden field to make sure something will be sent back to the
        # server if all checkboxes are unchecked.
        hidden = @template.hidden_field_tag("#{object_name}[#{attribute}][]", "", :id => nil)

        wrap_rendered_collection(rendered_collection + hidden, options)
      end

      # Wrapper for using SimpleForm inside a default rails form.
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
        options[:wrapper] = self.options[:wrapper] if options[:wrapper].nil?
        options[:defaults] ||= self.options[:defaults]

        if self.class < ActionView::Helpers::FormBuilder
          options[:builder] ||= self.class
        else
          options[:builder] ||= SimpleForm::FormBuilder
        end
        fields_for(*(args << options), &block)
      end

      private

      def instantiate_collection_builder(builder_class, attribute, item, value, text, html_options)
        builder_class.new(self, attribute, item,
                          sanitize_attribute_name(attribute, value), text, value, html_options)
      end

      # Generate default options for collection helpers, such as :checked and
      # :disabled.
      def default_html_options_for_collection(item, value, options, html_options) #:nodoc:
        html_options = html_options.dup

        [:checked, :selected, :disabled].each do |option|
          current_option = options[option]
          next if current_option.nil?

          accept = if current_option.respond_to?(:call)
            current_option.call(item)
          else
            Array(current_option).map(&:to_s).include?(value.to_s)
          end

          if accept
            html_options[option] = true
          elsif option == :checked
            html_options[option] = false
          end
        end

        html_options
      end

      def sanitize_attribute_name(attribute, value) #:nodoc:
        "#{attribute}_#{value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}"
      end

      def render_collection(collection, value_method, text_method, options={}, html_options={}) #:nodoc:
        item_wrapper_tag   = options.fetch(:item_wrapper_tag, :span)
        item_wrapper_class = options[:item_wrapper_class]

        collection.map do |item|
          value = value_for_collection(item, value_method)
          text  = value_for_collection(item, text_method)
          default_html_options = default_html_options_for_collection(item, value, options, html_options)

          rendered_item = yield item, value, text, default_html_options

          item_wrapper_tag ? @template.content_tag(item_wrapper_tag, rendered_item, :class => item_wrapper_class) : rendered_item
        end.join.html_safe
      end

      def value_for_collection(item, value) #:nodoc:
        value.respond_to?(:call) ? value.call(item) : item.send(value)
      end

      def wrap_rendered_collection(collection, options)
        wrapper_tag = options[:collection_wrapper_tag]

        if wrapper_tag
          wrapper_class = options[:collection_wrapper_class]
          @template.content_tag(wrapper_tag, collection, :class => wrapper_class)
        else
          collection
        end
      end
    end
  end
end

module ActionView::Helpers
  class FormBuilder
    include SimpleForm::ActionViewExtensions::Builder
  end

  module FormOptionsHelper
    # Override Rails options_from_collection_for_select to handle lambdas/procs in
    # text and value methods, so it works the same way as collection_radio_buttons
    # and collection_check_boxes in SimpleForm. If none of text/value methods is a
    # callable object, then it just delegates back to original collection select.
    # FIXME: remove when support only Rails 4.0 forward
    #        https://github.com/rails/rails/commit/9035324367526af0300477a58b6d3efc15d1a5a8
    alias :original_options_from_collection_for_select :options_from_collection_for_select
    def options_from_collection_for_select(collection, value_method, text_method, selected = nil)
      if value_method.respond_to?(:call) || text_method.respond_to?(:call)
        collection = collection.map do |item|
          value = value_for_collection(item, value_method)
          text  = value_for_collection(item, text_method)

          [value, text]
        end

        value_method, text_method = :first, :last
        selected = extract_selected_and_disabled_and_call_procs selected, collection
      end

      original_options_from_collection_for_select collection, value_method, text_method, selected
    end

    private

    def extract_selected_and_disabled_and_call_procs(selected, collection)
      selected, disabled = extract_selected_and_disabled selected
      selected_disabled = { :selected => selected, :disabled => disabled }

      selected_disabled.each do |key, check|
        if check.is_a? Proc
          values = collection.map { |option| option.first if check.call(option.first) }
          selected_disabled[key] = values
        end
      end
    end

    def value_for_collection(item, value) #:nodoc:
      value.respond_to?(:call) ? value.call(item) : item.send(value)
    end
  end

  # Backport Rails fix to checkbox tag element, which does not generate the
  # hidden input when given nil as unchecked value. This is to make SimpleForm
  # collection check boxes helper to work fine with nested boolean style, when
  # they are wrapped in labels. Without that, clicking in the label would
  # actually change the hidden input, instead of the checkbox.
  # FIXME: remove when support only Rails >= 3.2.2.
  class InstanceTag
    def to_check_box_tag(options = {}, checked_value = "1", unchecked_value = "0")
      options = options.stringify_keys
      options["type"]     = "checkbox"
      options["value"]    = checked_value
      if options.has_key?("checked")
        cv = options.delete "checked"
        checked = cv == true || cv == "checked"
      else
        checked = self.class.check_box_checked?(value(object), checked_value)
      end
      options["checked"] = "checked" if checked
      if options["multiple"]
        add_default_name_and_id_for_value(checked_value, options)
        options.delete("multiple")
      else
        add_default_name_and_id(options)
      end
      hidden = unchecked_value ? tag("input", "name" => options["name"], "type" => "hidden", "value" => unchecked_value, "disabled" => options["disabled"]) : "".html_safe
      checkbox = tag("input", options)
      hidden + checkbox
    end
  end
end
