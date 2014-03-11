module SimpleForm
  module Components
    module HTML5
      def initialize(*)
        @html5 = false
      end

      def html5(wrapper_options = nil)
        @html5 = true
        if has_required?
          input_html_options[:required] = true
          input_html_options[:'aria-required'] = true
        end
        nil
      end

      def html5?
        @html5
      end

      def has_required?
        # We need to check browser_validations because
        # some browsers are still checking required even
        # if novalidate was given.
        required_field? && SimpleForm.browser_validations
      end
    end
  end
end
