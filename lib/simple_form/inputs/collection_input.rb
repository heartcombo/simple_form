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
        label_method, value_method = detect_collection_methods
        @builder.send(:"collection_#{input_type}", attribute_name, collection,
                      value_method, label_method, input_options, input_html_options)
      end

      def input_options
        options = super
        options[:include_blank] = true unless skip_include_blank?
        options
      end

      private

      def collection
        @collection ||= (options.delete(:collection) || self.class.boolean_collection).to_a
      end

      # Select components does not allow the required html tag.
      def has_required?
        super && input_type != :select
      end

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
      def detect_collection_methods
        label, value = options.delete(:label_method), options.delete(:value_method)

        unless label && value
          common_method_for = detect_common_display_methods
          label ||= common_method_for[:label]
          value ||= common_method_for[:value]
        end

        [label, value]
      end

      def detect_common_display_methods
        collection_classes = detect_collection_classes

        if collection_classes.include?(Array)
          { :label => :first, :value => :last }
        elsif collection_includes_basic_objects?(collection_classes)
          { :label => :to_s, :value => :to_s }
        else
          sample = collection.first || collection.last

          { :label => SimpleForm.collection_label_methods.find { |m| sample.respond_to?(m) },
            :value => SimpleForm.collection_value_methods.find { |m| sample.respond_to?(m) } }
        end
      end

      def detect_collection_classes
        collection.map { |e| e.class }.uniq
      end

      def collection_includes_basic_objects?(collection_classes)
        (collection_classes & [
          String, Integer, Fixnum, Bignum, Float, NilClass, Symbol, TrueClass, FalseClass
        ]).any?
      end
    end
  end
end
