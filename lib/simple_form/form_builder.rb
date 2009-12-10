module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute, :column,
                :input_type, :options

    def input(*args)
      define_simple_form_attributes(*args)

      component = SimpleForm.terminator
      SimpleForm.components.reverse.each do |klass|
        next if @options[klass.basename] == false
        component = klass.new(self, component)
      end

      component.call
    end

    def error(*args)
      define_simple_form_attributes(*args)
      SimpleForm::Components::Error.new(self, SimpleForm.terminator).call
    end

    def hint(*args)
      define_simple_form_attributes(*args)
      SimpleForm::Components::Hint.new(self, SimpleForm.terminator).call
    end

    # TODO: as we are overriding default label method, we need a way to call the
    # default label from rails, or use content tags inside our own helpers.
    # Check whether we should remove label call, change method name or use content_tag
    def label(*args)
      # use default label if we pass the string as usually
      return super if args.second.is_a?(String)

      define_simple_form_attributes(*args)
      SimpleForm::Components::Label.new(self, SimpleForm.terminator).call
    end

  private

    def define_simple_form_attributes(*args)
      options = args.extract_options!
      attribute = args.shift

      @attribute, @options = attribute, options
      @column = find_attribute_column
      @input_type = default_input_type
    end

    def default_input_type
      return @options[:as].to_sym if @options[:as]
      return :select              if @options[:collection]

      input_type = column.try(:type)

      case input_type
        when :timestamp
          :datetime
        when :string, nil
          @attribute.to_s =~ /password/ ? :password : :string
        else
          input_type
      end
    end

    def find_attribute_column
      @object.column_for_attribute(@attribute) if @object.respond_to?(:column_for_attribute)
    end

  end
end
