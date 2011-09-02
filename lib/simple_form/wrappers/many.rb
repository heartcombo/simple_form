module SimpleForm
  module Wrappers
    class Many
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

        wrap(input, options, content)
      end

      private

      def wrap(input, options, content)
        tag = options[:"#{namespace}_tag"]  || @tag
        return content unless tag

        opts  = options[:"#{namespace}_html"] || {}
        opts[:class] = (@class << opts[:class]).join(' ').strip unless @class.empty?
        input.template.content_tag(tag, content, opts)
      end
    end
  end
end