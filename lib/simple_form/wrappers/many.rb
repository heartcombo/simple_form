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
      attr_reader :namespace, :defaults, :components
      alias :to_sym :namespace

      def initialize(namespace, components, defaults={})
        @namespace  = namespace
        @components = components
        @defaults   = defaults
        @defaults[:tag]   = :div unless @defaults.key?(:tag)
        @defaults[:class] = Array(@defaults[:class])
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

      def find(name)
        return self if namespace == name

        @components.each do |c|
          if c.is_a?(Symbol)
            return nil if c == namespace
          elsif value = c.find(name)
            return value
          end
        end

        nil
      end

      private

      def wrap(input, options, content)
        return content if options[namespace] == false

        tag = (namespace && options[:"#{namespace}_tag"]) || @defaults[:tag]
        return content unless tag

        klass = html_classes(input, options)
        opts  = html_options(options)
        opts[:class] = options_classes(klass, opts)
        input.template.content_tag(tag, content, opts)
      end

      def html_options(options)
        options[:"#{namespace}_html"] || {}
      end

      def html_classes(input, options)
        @defaults[:class].dup
      end

      # check wrappers is bootstrap3
      # maybe better to if use bootstrap3 wrappers
      def options_classes(klass, opts)
        # chech if use bootstrap3 stylesheet
        # replace default class with options[:class]
        if SimpleForm.default_wrapper == :bootstrap3 && opts[:class] && 
          opts[:class] =~ /(col-xs-|col-sm-|col-md-|col-lg-)/
          opts[:class].strip
        else
          (klass << opts[:class]).join(' ').strip unless klass.empty?
        end
      end
    end
  end
end
