module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Make the template accessible for components
    attr_reader :template

    def input(attribute, options={})
      input_type = default_input_type(attribute, options)

      pieces = SimpleForm.components.collect do |klass|
        next if options[klass.basename] == false
        klass.new(self, attribute, input_type, options).generate
      end

      wrap_content(pieces.compact.join)
    end

  private

    def wrap_content(content)
      if SimpleForm.wrapper_tag
        @template.content_tag(SimpleForm.wrapper_tag, content)
      else
        content
      end
    end

    def default_input_type(attribute, options)
      return options[:as].to_sym if options[:as]
      return :select             if options[:collection]

      column = @object.column_for_attribute(attribute)
      input_type = column.type

      case input_type
        when :timestamp
          :datetime
        when :string, nil
          attribute.to_s =~ /password/ ? :password : :string
        else
          input_type
      end
    end

  end
end
