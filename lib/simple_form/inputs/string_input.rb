module SimpleForm
  module Inputs
    class StringInput < Base
      extend MapType

      map_type :string, :email, :search, :tel, :url,  :to => :text_field
      map_type :password,                             :to => :password_field

      def input
        input_html_options[:size]      ||= [limit, SimpleForm.default_input_size].compact.min
        input_html_options[:maxlength] ||= limit if limit && SimpleForm.html5
        if password? || SimpleForm.html5
          input_html_options[:type]    ||= input_type unless string?
        end

        @builder.send(input_method, attribute_name, input_html_options)
      end

      def input_html_classes
        string? ? super : super.unshift("string")
      end

    protected

      def limit
        column && column.limit
      end

      def has_placeholder?
        placeholder_present?
      end

      def string?
        input_type == :string
      end

      def password?
        input_type == :password
      end
    end
  end
end
