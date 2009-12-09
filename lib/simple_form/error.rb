module SimpleForm
  class Error < AbstractComponent
    def valid?
      !hidden_input? && !errors.blank?
    end

    def errors
      @errors ||= object.errors[@attribute]
    end

    def content
      Array(errors).to_sentence
    end
  end
end
