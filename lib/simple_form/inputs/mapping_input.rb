module SimpleForm
  module Inputs
    # Uses MapType to handle basic input types.
    class MappingInput < Base
      extend MapType

      map_type :password, :to => :password_field
      map_type :text,     :to => :text_area
      map_type :file,     :to => :file_field

      def input
        @builder.send(input_method, attribute_name, input_html_options)
      end

    private

      def input_method
        self.class.mappings[input_type] or
          raise("Could not find method for #{input_type.inspect}")
      end

      def has_placeholder?
        (text? || password?) && placeholder_present?
      end

      def password?
        input_type == :password
      end

      def text?
        input_type == :text
      end
    end
  end
end
