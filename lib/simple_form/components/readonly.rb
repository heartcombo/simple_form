module SimpleForm
  module Components
    # Needs to be enabled in order to do automatic lookups.
    module Readonly
      def readonly
        if readonly_attribute?
          input_html_options[:readonly] ||= true
          add_readonly_class!
        end

        nil
      end

      private

      def readonly_attribute?
        object.class.respond_to?(:readonly_attributes) &&
          object.persisted? &&
          object.class.readonly_attributes.include?(attribute_name)
      end

      def add_readonly_class!
        input_html_classes.push(:readonly).compact! unless input_html_classes.include?(:readonly)
      end
    end
  end
end
