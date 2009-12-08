require 'simple_form/label'
require 'simple_form/input'

module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include SimpleForm::Label
    include SimpleForm::Input

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @options.assert_valid_keys(:as, :label, :required, :options, :html)

      @input_type = (@options[:as] || default_input_type).to_sym

      label = generate_label
      input = generate_input

      label << input
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
  end
end
