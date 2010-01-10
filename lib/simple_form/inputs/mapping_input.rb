module SimpleForm
  module Inputs
    # Uses MapType to handle basic input types.
    class MappingInput < Base
      extend MapType

      map_type :boolean,  :to => :check_box
      map_type :password, :to => :password_field
      map_type :text,     :to => :text_area
      map_type :file,     :to => :file_field

      def input
        @builder.send(input_method, attribute_name, input_html_options)
      end

      def input_method
        method = self.class.mappings[input_type]
        raise "Could not find method for #{input_type.inspect}" unless method
        method
      end
    end
  end
end
