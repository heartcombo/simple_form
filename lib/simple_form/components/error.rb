module SimpleForm
  module Components
    class Error < Base
      def valid?
        object && !hidden_input? && !errors.blank?
      end

      def errors
        @errors ||= object.errors[@attribute]
      end

      def content
        Array(errors).to_sentence
      end
    end
  end
end
