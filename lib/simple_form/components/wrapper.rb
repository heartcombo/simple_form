module SimpleForm
  module Components
    # Wrapper component. The last the will be executed by default, responsible
    # for wrapping the entire stack in a wrapper tag if it is configured.
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
