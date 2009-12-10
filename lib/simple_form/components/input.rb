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

      def generate
        html_options = @options[:html] || {}
        html_options[:class] = default_css_classes(html_options[:class])
        @options[:options] ||= {}

        mapping = self.class.mappings[@input_type]
        raise "Invalid input type #{@input_type.inspect}" unless mapping

        args = [ @attribute ]
        apply_collection_behavior(args) if mapping.collection
        apply_options_behavior(args)    if mapping.options
        args << html_options

        @builder.send(mapping.method, *args)
      end

    protected

      def apply_collection_behavior(args)
        collection = (@options[:collection] || self.class.boolean_collection).to_a
        detect_collection_methods(collection, @options)

        @options[:options][:include_blank] = true unless @options[:options].key?(:include_blank)
        args.push(collection, @options[:value_method], @options[:label_method])
      end

      def apply_options_behavior(args)
        args << @options[:options]
      end

      def detect_collection_methods(collection, options)
        case collection.first
          when Array
            label, value = :first, :last
          when Integer
            value = :to_i
          when String
            # Do nothing ...
          else
            # TODO Implement detection logic
        end

        options[:label_method] ||= label || :to_s
        options[:value_method] ||= value || :to_s
      end
    end
  end
end
