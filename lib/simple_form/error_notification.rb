module SimpleForm
  class ErrorNotification
    delegate :object, :object_name, :template, :to => :@builder
    include SimpleForm::Helpers::HasErrors

    def initialize(builder, options)
      @builder = builder
      @message = options.delete(:message)
      @options = options
    end

    def render
      if has_errors?
        template.content_tag(error_notification_tag, error_message, html_options)
      end
    end

    protected

    def error_message
      @message || translate_error_notification
    end

    def error_notification_tag
      SimpleForm.error_notification_tag
    end

    def html_options
      @options[:class] = "#{SimpleForm.error_notification_class} #{@options[:class]}".strip
      @options[:id] = SimpleForm.error_notification_id if SimpleForm.error_notification_id
      @options
    end

    def translate_error_notification
      lookups = []
      lookups << :"#{object_name}"
      lookups << :default_message
      lookups << "Some errors were found, please take a look:"
      I18n.t(lookups.shift, :scope => :"simple_form.error_notification", :default => lookups)
    end
  end
end
