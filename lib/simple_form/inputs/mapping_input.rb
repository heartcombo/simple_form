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

      def input_html_options
        input_options = super
        input_options[:cols]        ||= cols if input_type == :text and has_cols?
        input_options[:rows]        ||= rows if input_type == :text and has_rows?
        input_options
      end
      
      def has_cols?
        options[:cols] != false && cols.present?
      end

      def cols
        @cols ||= options[:cols] || translate(:cols)
      end
      
      def has_rows?
        options[:rows] != false && rows.present?
      end

      def rows
        @rows ||= options[:rows] || translate(:rows)
      end
      
    private

      def input_method
        self.class.mappings[input_type] or
          raise("Could not find method for #{input_type.inspect}")
      end
    end
  end
end
