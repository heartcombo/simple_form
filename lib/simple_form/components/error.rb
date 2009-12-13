module SimpleForm
  module Components
    # General error component. Responsible for verifying whether an object
    # exists and there are errors on the attribute being generated. If errors
    # exists than the component will be rendered, otherwise will be skipped.
    class Error < Base
      def valid?
        object && !hidden_input? && !errors.blank?
      end

      def errors
        @errors ||= (errors_on_attribute + errors_on_association).compact
      end

      def errors_on_attribute
        Array(object.errors[attribute_name])
      end

      def errors_on_association
        reflection ? Array(object.errors[reflection.name]) : []
      end

      def content
        component_tag errors.to_sentence
      end
    end
  end
end
