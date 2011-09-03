module SimpleForm
  module Wrappers
    # A wrapper is an object that holds several components and render them.
    # A component may either be a symbol or any object that responds to `render`.
    # This API allows inputs/components to be easily wrapped, removing the
    # need to modify the code only to wrap input in an extra tag.
    #
    # `Many` represents a wrapper around several components at the same time.
    # It may optionally receive a namespace, allowing it to be configured
    # on demand on input generation.
    class Many
      include Enumerable

      attr_reader :namespace, :defaults, :components
      alias :to_sym :namespace

      def initialize(namespace, components, defaults={})
        @namespace  = namespace
        @components = components
        @defaults   = defaults
        @defaults[:class] = Array.wrap(@defaults[:class])
      end

      def render(input)
        content = "".html_safe
        options = input.options

        components.each do |component|
          next if options[component] == false
          rendered = component.respond_to?(:render) ? component.render(input) : input.send(component)
          content.safe_concat rendered.to_s if rendered
        end

        wrap(input, options, content)
      end

      def each
        @components.each { |c| yield(c) }
      end

      private

      def wrap(input, options, content)
        return content if options[namespace] == false

        tag = (namespace && options[:"#{namespace}_tag"]) || @defaults[:tag]
        return content unless tag

        klass = html_classes(input, options)
        opts  = options[:"#{namespace}_html"] || {}
        opts[:class] = (klass << opts[:class]).join(' ').strip unless klass.empty?
        input.template.content_tag(tag, content, opts)
      end

      def html_classes(input, options)
        @defaults[:class].dup
      end
    end
  end
end