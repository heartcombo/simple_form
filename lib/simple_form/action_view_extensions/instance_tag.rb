module SimpleForm
  module ActionViewExtensions
    module InstanceTag #:nodoc:
      # Overwrite to_check_box_tag to make it available to work with :multiple => true
      def to_check_box_tag(options = {}, checked_value = "1", unchecked_value = "0")
        options = options.stringify_keys
        options["type"]  = "checkbox"
        options["value"] = checked_value

        if options.has_key?("checked")
          cv = options.delete "checked"
          checked = cv == true || cv == "checked"
        else
          checked = self.class.check_box_checked?(value(object), checked_value)
        end
        options["checked"] = "checked" if checked

        # The only part added to deal with multiple check box is this conditional.
        if options["multiple"]
          add_default_name_and_id_for_value(checked_value, options)
          options.delete("multiple")
        else
          add_default_name_and_id(options)
        end

        hidden   = tag("input", "name" => options["name"], "type" => "hidden", "value" => options['disabled'] && checked ? checked_value : unchecked_value)
        checkbox = tag("input", options)

        result = hidden + checkbox
        result.respond_to?(:html_safe) ? result.html_safe : result
      end
    end
  end
end

ActionView::Helpers::InstanceTag.send :remove_method, :to_check_box_tag
ActionView::Helpers::InstanceTag.send :include, SimpleForm::ActionViewExtensions::InstanceTag
