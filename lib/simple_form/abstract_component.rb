module SimpleForm
  class AbstractComponent
    attr_reader :builder, :attribute, :input_type, :options

    def self.basename
      @basename ||= name.split("::").last
    end

    def initialize(builder, attribute, input_type, options)
      @builder    = builder
      @attribute  = attribute
      @input_type = input_type
      @options    = options 
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
      template.content_tag(:span, content, :class => basename.underscore)
    end

    def translate(default='')
      lookups = [ :"#{@builder.object_name}.#{@attribute}", :"#{@attribute}", default ]
      I18n.t(lookups.shift, :scope => :"simple_form.#{basename.tableize}", :default => lookups)
    end
  end
end