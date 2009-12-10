module SimpleForm
  module Components
    class Wrapper < Base
      include RequiredHelpers

      def call
        if SimpleForm.wrapper_tag
          template.content_tag(SimpleForm.wrapper_tag, @component.call, :class => default_css_classes)
        else
          @component.call
        end
      end
    end
  end
end