module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    def input(attribute, options={})
      input_type = (options.delete(:as) || default_input_type(attribute)).to_sym
      html_options = options.delete(:html) || {}
      html_options[:class] = "#{html_options[:class]} #{input_type}".strip

      input_field = case input_type
        when :boolean then check_box(attribute, html_options)
        when :radio   then
          ['yes', 'no'].inject('') do |result, value|
            result << radio_button(attribute, value, html_options)
          end
        when :text   then text_area(attribute, html_options)
        when :datetime, :timestamp then
          datetime_select(attribute, options, html_options)
        when :date then
          date_select(attribute, options, html_options)
        when :time then
          time_select(attribute, options, html_options)
        else text_field(attribute, html_options)
      end

      label = if options[:label] == false
        ''
      else
        unless options[:label]
          default = @object.try(:human_attribute_name, attribute.to_s) || attribute.to_s.humanize
          options[:label] ||= I18n.t("views.labels.#{@object.class.name.underscore}.#{attribute}", :default => default)
        end
        label(attribute, options[:label])
      end

      label << input_field
    end

    private

      def default_input_type(attribute)
        input_type = @object.try(:column_for_attribute, attribute)
        case input_type
          when nil then :string
          when :timestamp then :datetime
          else input_type
        end
      end
  end
end
