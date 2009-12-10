module SimpleForm
  module RequiredHelpers
    # Attribute is always required, unless the user has defined the opposite.
    def attribute_required?
      options[:required] != false
    end

    def required_class
      attribute_required? ? :required : :optional
    end

    # Creates default required classes for attributes, such as .string and
    # .decimal, based on input type, and required class
    def default_css_classes(merge_class=nil)
      "#{input_type} #{required_class} #{merge_class}".strip
    end

    # When components may be required, default component html options always
    # must include default css classes.
    def component_html_options
      html_options = super
      html_options[:class] = default_css_classes(html_options[:class])
      html_options
    end
  end
end
