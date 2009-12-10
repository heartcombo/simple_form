module SimpleForm
  module Components
    class Base
      attr_reader :builder, :attribute, :input_type, :options

      def self.basename
        @basename ||= name.split("::").last.underscore.to_sym
      end

      def initialize(builder, component)
        @builder    = builder
        @component  = component
        @attribute  = @builder.attribute
        @input_type = @builder.input_type
        @options    = @builder.options 
      end

      def call
        generate + @component.call
      end

      def generate
        return "" unless valid?
        component_tag(content).to_s
      end

      def valid?
        true
      end

      def template
        @builder.template
      end

      def object
        @builder.object
      end

      def hidden_input?
        @input_type == :hidden
      end

      def basename
        self.class.basename
      end

      def component_tag(content)
        template.content_tag(SimpleForm.component_tag, content, :class => basename)
      end

      def translate(default='')
        lookups = [ :"#{@builder.object_name}.#{@attribute}", :"#{@attribute}", default ]
        I18n.t(lookups.shift, :scope => :"simple_form.#{basename.to_s.pluralize}", :default => lookups)
      end
    end
  end
end