class Symbol
  def render(input)
    input.send(self)
  end

  def namespace
    self
  end
end

module SimpleForm
  class Renderer
    attr_reader :namespace, :defaults, :components

    def initialize(namespace, *args)
      options = args.extract_options!
      @tag    = options[:tag]
      @class  = Array.wrap(options[:class])

      @namespace  = namespace
      @components = args
    end

    def render(input)
      content = "".html_safe
      options = input.options
      components.each do |component|
        next if options[component] == false
        rendered = component.render(input)
        content.safe_concat rendered.to_s if rendered
      end
      # TODO: Break this into single renderer and multiple renderer
      wrap(input, content) unless content.empty?
    end

    private

    def wrap(input, content)
      tag = input.options[:"#{namespace}_tag"]  || @tag
      return content unless tag

      opts  = input.options[:"#{namespace}_html"] || {}
      opts[:class] = (@class << opts[:class]).join(' ').strip unless @class.empty?
      input.template.content_tag(tag, content, opts)
    end
  end
end