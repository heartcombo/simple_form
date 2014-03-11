module SimpleForm
  module Inputs
    class PasswordInput < Base
      enable :placeholder, :maxlength

      def input(context)
        @builder.password_field(attribute_name, merged_input_options(context.options))
      end
    end
  end
end
