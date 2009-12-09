require 'simple_form/abstract_component'

require 'simple_form/label'
require 'simple_form/input'
require 'simple_form/hint'
require 'simple_form/error'


module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Make the template accessible for components
    attr_reader :template

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @options.assert_valid_keys(:as, :label, :required, :hint, :options, :html,
                                 :collection, :label_method, :value_method)

      @input_type = (@options[:as] || default_input_type).to_sym

      label  = Label.new(self, @attribute, @input_type, @options).generate unless @options[:label] == false
      input = Input.new(self, @attribute, @input_type, @options).generate
      hint  = Hint.new(self, @attribute, @input_type, @options).generate unless @options[:hint] == false
      error = Error.new(self, @attribute, @input_type, @options).generate

      label.to_s << input << hint.to_s << error
    end

    private

      def default_input_type
        column = @object.column_for_attribute(@attribute)
        input_type = column.type
        case input_type
          when :decimal, :integer then :numeric
          when :timestamp then :datetime
          when nil, :string then
            @attribute.to_s =~ /password/ ? :password : :string
          else input_type
        end
      end

  end
end
