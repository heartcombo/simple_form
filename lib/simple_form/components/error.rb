module SimpleForm
  module Components
    # General error component. Responsible for verifying whether an object
    # exists and there are errors on the attribute being generated. If errors
    # exists then the component will be rendered, otherwise will be skipped.
    class Error < Base
      def valid?
        object && !hidden_input? && !errors.blank?
      end

      def errors
        @errors ||= object.errors[attribute]
      end

      def content
        component_tag Array(errors).to_sentence
      end
    end
  end
end
