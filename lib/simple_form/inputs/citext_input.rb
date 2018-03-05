# frozen_string_literal: true
module SimpleForm
  module Inputs
    class CitextInput < SimpleForm::Inputs::StringInput
      def input(_wrapper_options = nil)
        if email?
          @builder.email_field(attribute_name, input_html_options)
        else
          @builder.text_field(attribute_name, input_html_options)
        end
      end

      private

      def email?
        attribute_name == :email
      end
    end
  end
end
