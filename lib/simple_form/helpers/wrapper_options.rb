module SimpleForm
  module Helpers
    module WrapperOptions
      private

      def merge_wrapper_options(options, context)
        if context
          options.merge(context.options) do |_, oldval, newval|
            if Array === oldval
              oldval + Array(newval)
            end
          end
        else
          options
        end
      end
    end
  end
end
