module SimpleForm
  module Components
    # The component is the core of SimpleForm. SimpleForm can be customized simply
    # with the addition of new components to the component stack. A component just
    # need to be initialized with two values, the builder and the next component to
    # be invoked and respond to call.
    #
    # The Base component is a raw component with some helpers and a default behavior
    # of prepending the content available in the method content.
    class Base
      delegate :template, :object, :object_name, :column, :attribute,
               :input_type, :options, :to => :@builder

      def self.basename
        @basename ||= name.split("::").last.underscore.to_sym
      end

      def initialize(builder, component)
        @builder    = builder
        @component  = component
      end

      def call
        return @component.call unless valid?
        content + @component.call
      end

      def valid?
        true
      end

      def hidden_input?
        input_type == :hidden
      end

      def basename
        self.class.basename
      end

      def component_tag(content)
        template.content_tag(SimpleForm.component_tag, content, :class => basename)
      end

      def translate(default='')
        lookups = [ :"#{object_name}.#{attribute}", :"#{attribute}", default ]
        I18n.t(lookups.shift, :scope => :"simple_form.#{basename.to_s.pluralize}", :default => lookups)
      end
    end
  end
end