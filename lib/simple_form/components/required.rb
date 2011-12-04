module SimpleForm
  module Components
    module Required
      def required
        input_html_options[:required] = true if has_required?
        nil
      end

      def has_required?
        required_field?
      end
    end
  end
end