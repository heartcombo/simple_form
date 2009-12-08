require 'simple_form/label'

module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include SimpleForm::Label

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @options.assert_valid_keys(:as, :label, :options, :html)

      label = generate_label
      input = generate_input

      label << input
    end

    private

      def generate_input
        input_type = (@options[:as] || default_input_type).to_sym
        html_options = @options[:html] || {}
        html_options[:class] = "#{html_options[:class]} #{input_type}".strip
        @options[:options] ||= {}

        input_field = case input_type
          when :boolean then
            check_box(@attribute, html_options)
          when :radio   then
            ['yes', 'no'].inject('') do |result, value|
              result << radio_button(@attribute, value, html_options)
            end
          when :text then
            text_area(@attribute, html_options)
          when :datetime then
            datetime_select(@attribute, @options[:options], html_options)
          when :date then
            date_select(@attribute, @options[:options], html_options)
          when :time then
            time_select(@attribute, @options[:options], html_options)
          else
            text_field(@attribute, html_options)
        end
      end

      def default_input_type
        input_type = @object.try(:column_for_attribute, @attribute)
        case input_type
          when nil then :string
          when :timestamp then :datetime
          else input_type
        end
      end
  end
end
