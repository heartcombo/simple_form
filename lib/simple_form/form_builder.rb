require 'simple_form/label'
require 'simple_form/input'
require 'simple_form/hint'
require 'simple_form/error'

module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include SimpleForm::Label
    include SimpleForm::Input
    include SimpleForm::Hint
    include SimpleForm::Error

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @options.assert_valid_keys(:as, :label, :required, :hint, :options, :html)

      @input_type = (@options[:as] || default_input_type).to_sym

      label = generate_label
      input = generate_input
      hint  = generate_hint
      error = generate_error

      label << input << hint << error
    end

    private

      def required_class
        'required' if attribute_required?
      end

      def attribute_required?
        true unless @options[:required] == false
      end

      def default_input_type
        input_type = @object.try(:column_for_attribute, @attribute)
        case input_type
          when nil then :string
          when :decimal then :numeric
          when :timestamp then :datetime
          when :string then
            @attribute.to_s =~ /password/ ? :password : :string
          else input_type
        end
      end

      def hidden_input?
        @input_type == :hidden
      end

      def translate_form(scope, default='')
        lookups = [:"#{@object_name}.#{@attribute}", :"#{@attribute}", default]
        translate(lookups.shift, :scope => :"simple_form.#{scope}", :default => lookups)
      end

      def translate(key, params={})
        I18n.t(key, {:scope => :simple_form}.merge!(params))
      end

  end
end
