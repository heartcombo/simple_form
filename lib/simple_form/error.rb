module SimpleForm
  module Error

    private

      def generate_error
        return '' unless errors = @object.errors[@attribute]
        errors = errors.is_a?(Array) ? errors.to_sentence : errors
        @template.content_tag(:span, errors, :class => 'error')
      end
  end
end
