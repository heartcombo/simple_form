module SimpleForm
  module Components
    module HTML5
      def initialize(*)
        @html5 = false
      end

      def html5
        @html5 = true
        input_html_options[:required] = true if has_required?
        nil
      end

      def html5?
        @html5
      end

      def has_required?
        required_field?
      end
    end
  end
end