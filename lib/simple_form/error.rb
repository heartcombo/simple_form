module SimpleForm
  class Error < AbstractComponent
    def valid?
      !hidden_input? && !errors.blank?
    end

    def errors
      @errors ||= object.errors[@attribute]
    end

    def content
      template.content_tag(:span, Array(errors).to_sentence, :class => 'error')
    end
  end
end
