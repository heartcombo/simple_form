module SimpleForm
  module Label

    private

      def generate_label
        return '' if @options[:label] == false
        label(@attribute, @options[:label] || translate_label)
      end

      def translate_label
        default = @object.try(:human_attribute_name, @attribute.to_s) || @attribute.to_s.humanize
        I18n.t("views.labels.#{@object_name}.#{@attribute}", :default => default)
      end
  end
end
