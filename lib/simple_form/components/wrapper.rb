module SimpleForm
  module Components
    class Wrapper < Base
      include RequiredHelpers

      def call
        if SimpleForm.wrapper_tag
          template.content_tag(SimpleForm.wrapper_tag, @component.call, component_html_options)
        else
          @component.call
        end
      end
    end
  end
end