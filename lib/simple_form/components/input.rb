module SimpleForm
  module Components
    class Input < Base
      include RequiredHelpers
      extend I18nCache
      extend MapType

      map_type :boolean,  :to => :check_box
      map_type :text,     :to => :text_area
      map_type :datetime, :to => :datetime_select, :options => true
      map_type :date,     :to => :date_select, :options => true
      map_type :time,     :to => :time_select, :options => true
      map_type :password, :to => :password_field
      map_type :hidden,   :to => :hidden_field
      map_type :select,   :to => :collection_select, :options => true, :collection => true
      map_type :radio,    :to => :collection_radio, :collection => true
      map_type :string,   :to => :text_field

      # Numeric types
      map_type :integer, :float, :decimal, :to => :text_field

      def self.boolean_collection
        i18n_cache :boolean_collection do
          [ [I18n.t(:"simple_form.true", :default => 'Yes'), true],
            [I18n.t(:"simple_form.false", :default => 'No'), false] ]
        end
      end

      def content
        options[:options] ||= {}
        mapping = self.class.mappings[input_type]
        raise "Invalid input type #{input_type.inspect}" unless mapping

        args = [ attribute ]
        apply_collection_behavior(args) if mapping.collection
        apply_options_behavior(args)    if mapping.options
        apply_html_options(args)

        @builder.send(mapping.method, *args)
      end

    protected

      def apply_collection_behavior(args)
        collection = (options[:collection] || self.class.boolean_collection).to_a
        detect_collection_methods(collection, options)

        options[:options][:include_blank] = true unless options[:options].key?(:include_blank)
        args.push(collection, options[:value_method], options[:label_method])
      end

      def apply_options_behavior(args)
        args << options[:options]
      end

      def apply_html_options(args)
        html_options = component_html_options

        if column && [:string, :password, :decimal, :float].include?(input_type)
          html_options[:maxlength] ||= column.limit
        end

        args << html_options
      end

      def detect_collection_methods(collection, options)
        sample = collection.first || collection.last

        case sample
          when Array
            label, value = :first, :last
          when Integer
            label, value = :to_s, :to_i
          when String, NilClass
            label, value = :to_s, :to_s
        end

        options[:label_method] ||= label || SimpleForm.collection_label_methods.find { |m| sample.respond_to?(m) }
        options[:value_method] ||= value || SimpleForm.collection_value_methods.find { |m| sample.respond_to?(m) }
      end
    end
  end
end
