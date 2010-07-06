module SimpleForm
  class ErrorNotification
    delegate :object, :object_name, :template, :to => :@builder

    def initialize(builder, options)
      @builder = builder
      @options = options
    end

    def render
      if has_errors?
        error_message = @options.delete(:message) || translate_error_notification
        @options[:class] = "error_notification #{@options[:class]}".strip
        template.content_tag(error_notification_tag, error_message, @options)
      end
    end

    protected

    def error_notification_tag
      SimpleForm.error_notification_tag
    end

    def has_errors?
      object && object.respond_to?(:errors) && object.errors.present?
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