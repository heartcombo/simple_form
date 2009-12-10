module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Components used by the folder builder.
    # By default is [:label, :input, :hint, :error].
    cattr_accessor :components, :instance_writer => false
    @@components = [
      SimpleForm::Components::Label, SimpleForm::Components::Input,
      SimpleForm::Components::Hint,  SimpleForm::Components::Error
    ]

    # Make the template accessible for components
    attr_reader :template

    def input(attribute, options={})
      input_type = (options[:as] || default_input_type(attribute)).to_sym

      pieces = self.components.collect do |klass|
        next if options[klass.basename] == false
        klass.new(self, attribute, input_type, options).generate
      end

      pieces.compact.join
    end

    private

      def default_input_type(attribute)
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
