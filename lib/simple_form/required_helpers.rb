module SimpleForm
  module RequiredHelpers
    def attribute_required?
      options[:required] != false
    end

    def required_class
      attribute_required? ? :required : :optional
    end

    def default_css_classes(merge_class=nil)
      "#{input_type} #{required_class} #{merge_class}".strip
    end

    def component_html_options
      html_options = super
      html_options[:class] = default_css_classes(html_options[:class])
      html_options
    end
  end
end