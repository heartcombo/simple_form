require 'simple_form/required_component'

module SimpleForm
  module Input
    include RequiredComponent

    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end

    module ClassMethods
      def boolean_collection
        i18n_cache :boolean_collection do
          [ [I18n.t(:"simple_form.true", :default => 'Yes'), true],
            [I18n.t(:"simple_form.false", :default => 'No'), false] ]
        end
      end
    end

    private

      def generate_input
        html_options = @options[:html] || {}
        html_options[:class] = default_css_classes(html_options[:class])
        @options[:options] ||= {}

        mapping = self.class.mappings[@input_type]
        raise "Invalid input type #{@input_type.inspect}" unless mapping

        args = [ @attribute ]

        if mapping.collection
          collection = @options[:collection] || self.class.boolean_collection
          detect_collection_methods(collection, @options)
          args.push(collection, @options[:value_method], @options[:label_method])
        end

        args << @options[:options] if mapping.options
        args << html_options

        send(mapping.method, *args)
      end

      def detect_collection_methods(collection, options)
        sample = collection.first

        if sample.is_a?(Array) # TODO Test me
          options[:label_method] ||= :first
          options[:value_method] ||= :last
        elsif sample.is_a?(String) # TODO Test me
          options[:label_method] ||= :to_s
          options[:value_method] ||= :to_s
        elsif sample.is_a?(Numeric) # TODO Test me (including selected)
          options[:label_method] ||= :to_s
          options[:value_method] ||= :to_i
        else # TODO Implement collection label methods or something similar
          options[:label_method] ||= :to_s
          options[:value_method] ||= :to_s
        end
      end

  end
end
