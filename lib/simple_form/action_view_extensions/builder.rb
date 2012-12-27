module SimpleForm
  module ActionViewExtensions
    # A collection of methods required by simple_form but added to rails default form.
    # This means that you can use such methods outside simple_form context.
    module Builder
      # deprecated
      def collection_radio(*args, &block)
        SimpleForm.deprecation_warn "The `collection_radio` helper is deprecated, " \
          "please use `collection_radio_buttons` instead."
        collection_radio_buttons(*args, &block)
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
        options[:wrapper]  ||= self.options[:wrapper]
        options[:defaults] ||= self.options[:defaults]

        if self.class < ActionView::Helpers::FormBuilder
          options[:builder] ||= self.class
        else
          options[:builder] ||= SimpleForm::FormBuilder
        end
        fields_for(*(args << options), &block)
      end
    end
  end
end

module SimpleForm
  module Tags
    module CollectionExtensions
      private

      def render_collection
        item_wrapper_tag   = @options.fetch(:item_wrapper_tag, :span)
        item_wrapper_class = @options[:item_wrapper_class]

        @collection.map do |item|
          value = value_for_collection(item, @value_method)
          text  = value_for_collection(item, @text_method)
          default_html_options = default_html_options_for_collection(item, value)

          rendered_item = yield item, value, text, default_html_options

          item_wrapper_tag ? @template_object.content_tag(item_wrapper_tag, rendered_item, :class => item_wrapper_class) : rendered_item
        end.join.html_safe
      end

      def wrap_rendered_collection(collection, options)
        wrapper_tag = options[:collection_wrapper_tag]

        if wrapper_tag
          wrapper_class = options[:collection_wrapper_class]
          @template_object.content_tag(wrapper_tag, collection, :class => wrapper_class)
        else
          collection
        end
      end
    end

    class CollectionRadioButtons < ActionView::Helpers::Tags::CollectionRadioButtons
      include CollectionExtensions

      def render
        rendered_collection = render_collection do |item, value, text, default_html_options|
          builder = instantiate_builder(RadioButtonBuilder, item, value, text, default_html_options)

          if block_given?
            yield builder
          else
            render_component(builder)
          end
        end

        wrap_rendered_collection(rendered_collection, @options)
      end

      private

      def render_component(builder)
        builder.radio_button + builder.label(:class => "collection_radio_buttons")
      end
    end

    class CollectionCheckBoxes < ActionView::Helpers::Tags::CollectionCheckBoxes
      include CollectionExtensions

      def render
        rendered_collection = render_collection do |item, value, text, default_html_options|
          default_html_options[:multiple] = true
          builder = instantiate_builder(CheckBoxBuilder, item, value, text, default_html_options)

          if block_given?
            yield builder
          else
            render_component(builder)
          end
        end

        # Append a hidden field to make sure something will be sent back to the
        # server if all check boxes are unchecked.
        hidden = @template_object.hidden_field_tag("#{tag_name}[]", "", :id => nil)

        wrap_rendered_collection(rendered_collection + hidden, @options)
      end

      private

      def render_component(builder)
        builder.check_box + builder.label(:class => "collection_check_boxes")
      end
    end
  end
end

module ActionView::Helpers
  class FormBuilder
    include SimpleForm::ActionViewExtensions::Builder

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
    def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      SimpleForm::Tags::CollectionRadioButtons.new(@object_name, method, @template, collection, value_method, text_method, objectify_options(options), @default_options.merge(html_options)).render(&block)
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
    def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {}, &block)
      SimpleForm::Tags::CollectionCheckBoxes.new(@object_name, method, @template, collection, value_method, text_method, objectify_options(options), @default_options.merge(html_options)).render(&block)
    end
  end
end
