module SimpleForm
  module HasErrors
    def has_errors?
      object && object.respond_to?(:errors) && errors.present?
    end

  protected

    def errors
      object.errors
    end
  end
end
