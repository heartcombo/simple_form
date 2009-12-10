module SimpleForm
  module Components
    # Default input component, responsible for mapping column attributes from
    # database to inputs to be rendered.
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

      # Default boolean collection for use with selects/radios when no
      # collection is given. Always fallback to this boolean collection.
      # Texts can be translated using i18n in "simple_form.true" and
      # "simple_form.false" keys. See the example locale file.
      def self.boolean_collection
        i18n_cache :boolean_collection do
          [ [I18n.t(:"simple_form.true", :default => 'Yes'), true],
            [I18n.t(:"simple_form.false", :default => 'No'), false] ]
        end
      end

      # Generate the input through the mapped option. Apply correct behaviors
      # for collections and add options whenever the input requires it.
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

      # Applies default collection behavior, mapping the default collection to
      # boolean collection if it was not set, and defining default include_blank
      # option
      def apply_collection_behavior(args)
        collection = (options[:collection] || self.class.boolean_collection).to_a
        detect_collection_methods(collection, options)

        options[:options][:include_blank] = true unless options[:options].key?(:include_blank)
        args.push(collection, options[:value_method], options[:label_method])
      end

      # Apply default behavior for inputs that need extra options, such as date
      # and time selects.
      def apply_options_behavior(args)
        args << options[:options]
      end

      # Adds default html options to the input based on db column information.
      def apply_html_options(args)
        html_options = component_html_options

        if column && [:string, :password, :decimal, :float].include?(input_type)
          html_options[:maxlength] ||= column.limit
        end

        args << html_options
      end

      # Detect the right method to find the label and value for a collection.
      # If no label or value method are defined, will attempt to find them based
      # on default label and value methods that can be configured through
      # SimpleForm.collection_label_methods and
      # SimpleForm.collection_value_methods.
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
