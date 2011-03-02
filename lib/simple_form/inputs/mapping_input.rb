module SimpleForm
  module Inputs
    # Uses MapType to handle basic input types.
    class MappingInput < Base
      extend MapType

      map_type :text,     :to => :text_area
      map_type :file,     :to => :file_field

      def input
        @builder.send(input_method, attribute_name, input_html_options)
      end

    private

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
