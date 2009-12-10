module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute, :input_type, :options

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @input_type = default_input_type

      component = SimpleForm.terminator
      SimpleForm.components.reverse.each do |klass|
        next if @options[klass.basename] == false
        component = klass.new(self, component)
      end

      component.call
    end

  private

    def default_input_type
      return @options[:as].to_sym if @options[:as]
      return :select              if @options[:collection]

      input_type = if @object.respond_to?(:column_for_attribute)
        column = @object.column_for_attribute(@attribute)
        column.type if column
      end

      case input_type
        when :timestamp
          :datetime
        when :string, nil
          @attribute.to_s =~ /password/ ? :password : :string
        else
          input_type
      end
    end

  end
end
