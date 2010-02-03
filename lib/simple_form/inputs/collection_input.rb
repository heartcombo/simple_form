module SimpleForm
  module Inputs
    class CollectionInput < Base
      # Default boolean collection for use with selects/radios when no
      # collection is given. Always fallback to this boolean collection.
      # Texts can be translated using i18n in "simple_form.yes" and
      # "simple_form.no" keys. See the example locale file.
      def self.boolean_collection
        i18n_cache :boolean_collection do
          [ [I18n.t(:"simple_form.yes", :default => 'Yes'), true],
            [I18n.t(:"simple_form.no", :default => 'No'), false] ]
        end
      end

      def input
        collection = (options[:collection] || self.class.boolean_collection).to_a
        detect_collection_methods(collection, options)
        @builder.send(:"collection_#{input_type}", attribute_name, collection, options[:value_method],
                      options[:label_method], input_options, input_html_options)
      end

      def input_options
        options = super
        options[:include_blank] = true unless skip_include_blank?
        options
      end

    protected

      # Check if :include_blank must be included by default.
      def skip_include_blank?
        (options.keys & [:prompt, :include_blank, :default, :selected]).any? ||
          options[:input_html].try(:[], :multiple)
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