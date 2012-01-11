module SimpleForm
  module Wrappers
    # Provides the builder syntax for components. The builder provides
    # only one method (called `use`) and it allows the following invocations:
    #
    #     config.wrappers do |b|
    #       # Use a single component
    #       b.use :placeholder
    #
    #       # Use a component with specific wrapper options
    #       b.use :error, :tag => "span", :class => "error"
    #
    #       # Use a set of components by wrapping them in a tag+class.
    #       b.use :tag => "div", :class => "another" do |ba|
    #         ba.use :label
    #         ba.use :input
    #       end
    #
    #       # Use a set of components by wrapping them in a tag+class.
    #       # This wrapper is identified by :label_input, which means it can
    #       # be turned off on demand with `f.input :name, :label_input => false`
    #       b.use :label_input, :tag => "div", :class => "another" do |ba|
    #         ba.use :label
    #         ba.use :input
    #       end
    #     end
    #
    # The builder also accepts default options at the root level. This is usually
    # used if you want a component to be disabled by default:
    #
    #     config.wrappers :hint => false do |b|
    #       b.use :hint
    #       b.use :label_input
    #     end
    #
    # In the example above, hint defaults to false, which means it won't automatically
    # do the lookup anymore. It will only be triggered when :hint is explicitly set.
    class Builder
      def initialize(options)
        @options    = options
        @components = []
      end

      def use(name, options=nil, &block)
        add(name, options, &block)
      end

      def optional(name, options=nil, &block)
        @options[name] = false
        add(name, options, &block)
      end

      def to_a
        @components
      end

      private

      def add(name, options)
        if block_given?
          name, options = nil, name if name.is_a?(Hash)
          builder = self.class.new(@options)
          options ||= {}
          options[:tag] = :div if options[:tag].nil?
          yield builder
          @components << Many.new(name, builder.to_a, options)
        elsif options
          @components << Single.new(name, options)
        else
          @components << name
        end
      end
    end
  end
end