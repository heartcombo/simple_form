# frozen_string_literal: true
module SimpleForm
  module Components
    module AriaDescribedby
      def aria_describedby(wrapper_options = nil)
        ids = []
        ids << aria_error_id if options[:error] != false && has_errors?
        ids << aria_hint_id if has_hint?

        add_aria_describedby(ids) if ids.any?
        nil
      end

      private

      # The wrapper may render the error through :error or :full_error and the
      # input cannot tell which, so both get the same id.
      def aria_error_id
        id = component_html_id(:error_html) || component_html_id(:full_error_html) || @builder.field_id(attribute_name, :error)
        default_component_html_id(:error_html, id)
        default_component_html_id(:full_error_html, id)
        id
      end

      def aria_hint_id
        id = component_html_id(:hint_html) || @builder.field_id(attribute_name, :hint)
        default_component_html_id(:hint_html, id)
        id
      end

      def component_html_id(key)
        options[key] && options[key][:id]
      end

      def default_component_html_id(key, id)
        options[key] = { id: id }.merge(options[key] || {})
      end

      def add_aria_describedby(ids)
        aria = input_html_options[:aria]

        if aria.is_a?(Hash) && aria.key?(:describedby)
          input_html_options[:aria] = aria.merge(describedby: [aria[:describedby], *ids].compact.join(" "))
        else
          input_html_options[:'aria-describedby'] = [input_html_options[:'aria-describedby'], *ids].compact.join(" ")
        end
      end
    end
  end
end
