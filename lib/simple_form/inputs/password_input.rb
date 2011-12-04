module SimpleForm
  module Inputs
    class PasswordInput < Base
      def input
        add_size!
        add_maxlength!
        @builder.password_field(attribute_name, input_html_options)
      end
    end
  end
end
