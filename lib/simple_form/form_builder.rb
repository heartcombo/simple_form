module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute, :column,
                :input_type, :options

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @column = find_attribute_column
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
