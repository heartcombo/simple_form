module SimpleForm
  module Tags
    module CollectionExtensions
      private

      def render_collection
        item_wrapper_tag   = @options.fetch(:item_wrapper_tag, :span)
        item_wrapper_class = @options[:item_wrapper_class]

        validate_sanitized_values_option

        @collection.each_with_index.map do |item, idx|
          value = value_for_collection(item, @value_method)
          text  = value_for_collection(item, @text_method)
          sanitized_value = @options[:sanitized_values] ? @options[:sanitized_values][idx] : nil 

          default_html_options = default_html_options_for_collection(item, value)
          additional_html_options = option_html_attributes(item)
          sanitized_value_options = sanitized_value ? { sanitized_value: sanitized_value } : {}
          combined_options = default_html_options.merge(additional_html_options).merge(sanitized_value_options)

          rendered_item = yield item, value, text, combined_options

          if @options.fetch(:boolean_style, SimpleForm.boolean_style) == :nested
            label_options = default_html_options.slice(:index, :namespace)
            label_options['class'] = @options[:item_label_class]
            attr_value = sanitized_value || value
            rendered_item = @template_object.label(@object_name, sanitize_attribute_name(attr_value), rendered_item, label_options)
          end

          item_wrapper_tag ? @template_object.content_tag(item_wrapper_tag, rendered_item, class: item_wrapper_class) : rendered_item
        end.join.html_safe
      end

      def validate_sanitized_values_option
        return unless @options[:sanitized_values]
        return unless @options[:sanitized_values].length != @collection.length

        raise ArgumentError, ":sanitized_valutes must be an array of same length as :collection"
      end

      def wrap_rendered_collection(collection)
        wrapper_tag = @options[:collection_wrapper_tag]

        if wrapper_tag
          wrapper_class = @options[:collection_wrapper_class]
          @template_object.content_tag(wrapper_tag, collection, class: wrapper_class)
        else
          collection
        end
      end
    end

    class CollectionRadioButtons < ActionView::Helpers::Tags::CollectionRadioButtons
      include CollectionExtensions

      def render
        wrap_rendered_collection(super)
      end

      private

      def render_component(builder)
        builder.radio_button + builder.label(class: "collection_radio_buttons")
      end
    end

    class CollectionCheckBoxes < ActionView::Helpers::Tags::CollectionCheckBoxes
      include CollectionExtensions

      def render
        wrap_rendered_collection(super)
      end

      private

      def render_component(builder)
        builder.check_box + builder.label(class: "collection_check_boxes")
      end
    end
  end
end
