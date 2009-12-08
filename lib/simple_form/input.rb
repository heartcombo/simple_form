module SimpleForm
  module Input

    private

      def generate_input
        html_options = @options[:html] || {}
        html_options[:class] = "#{html_options[:class]} #{@input_type} #{required_class}".strip
        @options[:options] ||= {}

        input_field = case @input_type
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
          when :password then
            password_field(@attribute, html_options)
          else
            text_field(@attribute, html_options)
        end
      end

  end
end
