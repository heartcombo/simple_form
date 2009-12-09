module SimpleForm
  class Hint < AbstractComponent
    def valid?
      !hidden_input? && !content.blank?
    end

    def content
      @content ||= @options[:hint] || translate
    end
  end
end
