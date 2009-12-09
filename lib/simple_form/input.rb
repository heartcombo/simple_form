module SimpleForm
  module Input

    private

      def generate_input
        html_options = @options[:html] || {}
        html_options[:class] = default_css_classes(html_options[:class])
        @options[:options] ||= {}

        input_field = case @input_type
          when :boolean then
            check_box(@attribute, html_options)
          when :radio then
            boolean_collection.inject('') do |result, (text, value)|
              result << radio_button(@attribute, value, html_options) <<
                        label("#{@attribute}_#{value}", text, :class => default_css_classes)
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
          when :hidden then
            hidden_field(@attribute, html_options)
          else
            text_field(@attribute, html_options)
        end
      end

      def boolean_collection
        [['Yes', true], ['No', false]]
      end

  end
end
