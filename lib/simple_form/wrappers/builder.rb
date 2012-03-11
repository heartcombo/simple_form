module SimpleForm
  module Wrappers
    # Provides the builder syntax for components. The builder provides
    # three methods `use`, `optional` and `wrapper` and they allow the following invocations:
    #
    #     config.wrappers do |b|
    #       # Use a single component
    #       b.use :html5
    #
    #       # Use the component, but do not automatically lookup. It will only be triggered when
    #       # :placeholder is explicitly set.
    #       b.optional :placeholder
    #
    #       # Use a component with specific wrapper options
    #       b.use :error, :wrap_with => { :tag => "span", :class => "error" }
    #
    #       # Use a set of components by wrapping them in a tag+class.
    #       b.wrapper :tag => "div", :class => "another" do |ba|
    #         ba.use :label
    #         ba.use :input
    #       end
    #
    #       # Use a set of components by wrapping them in a tag+class.
    #       # This wrapper is identified by :label_input, which means it can
    #       # be turned off on demand with `f.input :name, :label_input => false`
    #       b.wrapper :label_input, :tag => "div", :class => "another" do |ba|
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
      
      #this triggers the use of this option
      def use(name, options=nil, &block)
        if block_given?
          ActiveSupport::Deprecation.warn "Passing a block to use is deprecated. " \
            "Please use wrapper instead of use."
          return wrapper(name, options, &block)
        end

        if options && options.keys != [:wrap_with]
          ActiveSupport::Deprecation.warn "Passing :tag, :class and others to use is deprecated. " \
            "Please invoke b.use #{name.inspect}, :wrap_with => #{options.inspect} instead."
          options = { :wrap_with => options }
        end

        if options && wrapper = options[:wrap_with]
          @components << Single.new(name, wrapper)
        else
          @components << name
        end
      end

      def optional(name, options=nil, &block)
        if block_given?
          ActiveSupport::Deprecation.warn "Passing a block to optional is deprecated. " \
            "Please use wrapper instead of optional."
          return wrapper(name, options, &block)
        end

        if options && options.keys != [:wrap_with]
          ActiveSupport::Deprecation.warn "Passing :tag, :class and others to optional is deprecated. " \
            "Please invoke b.optional #{name.inspect}, :wrap_with => #{options.inspect} instead."
          options = { :wrap_with => options }
        end

        @options[name] = false
        use(name, options, &block)
      end

      def wrapper(name, options=nil)
        if block_given?
          #setting name to nil if only a hash passed in
          name, options = nil, name if name.is_a?(Hash)
          
          #create a builder based on current options of parent
          builder = self.class.new(@options)
          
          
          options ||= {}
          #use div if nothing else supplied
          options[:tag] = :div if options[:tag].nil?
          
          #now run the block setup stuff (use, optional, and wrappers)
          yield builder
          
          #turn this builder into a Many object (wrapper for multiple @components) and 
          #add to parent @components
          @components << Many.new(name, builder.to_a, options)
        else
          raise ArgumentError, "A block is required as argument to wrapper"
        end
      end

      def to_a
        @components
      end
    end
  end
end
