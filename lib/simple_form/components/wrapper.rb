module SimpleForm
  module Components
    class Wrapper < Base
      def call
        if SimpleForm.wrapper_tag
          template.content_tag(SimpleForm.wrapper_tag, @component.call)
        else
          @component.call
        end
      end
    end
  end
end