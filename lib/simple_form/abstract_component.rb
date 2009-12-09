module SimpleForm
  class AbstractComponent
    attr_reader :builder, :attribute, :input_type, :options

    def initialize(builder, attribute, input_type, options)
      @builder    = builder
      @attribute  = attribute
      @input_type = input_type
      @options    = options 
    end

    def generate
      (valid? ? content : nil).to_s
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
  end
end