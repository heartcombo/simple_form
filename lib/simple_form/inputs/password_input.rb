module SimpleForm
  module Inputs
    class PasswordInput < Base
      def input
        input_html_options[:size] ||= [limit, SimpleForm.default_input_size].compact.min
        @builder.password_field(attribute_name, input_html_options)
      end

    protected

      def has_maxlength?
        true
      end

      def has_placeholder?
        true
      end
    end
  end
end
