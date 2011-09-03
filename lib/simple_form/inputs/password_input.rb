module SimpleForm
  module Inputs
    class PasswordInput < Base
      enable :maxlength, :placeholder

      def input
        input_html_options[:size] ||= [limit, SimpleForm.default_input_size].compact.min
        @builder.password_field(attribute_name, input_html_options)
      end
    end
  end
end
