module SimpleForm
  module RequiredHelpers
    def attribute_required?
      @options[:required] != false
    end

    def required_class
      attribute_required? ? :required : :optional
    end

    def attribute_required?
      @options[:required] != false
    end

    def default_css_classes(merge_class=nil)
      "#{@input_type} #{required_class} #{merge_class}".strip
    end
  end
end