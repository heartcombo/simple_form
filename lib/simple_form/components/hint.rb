module SimpleForm
  module Components
    class Hint < Base
      def valid?
        !hidden_input? && !content.blank?
      end

      def content
        @content ||= @options[:hint] || translate
      end
    end
  end
end
