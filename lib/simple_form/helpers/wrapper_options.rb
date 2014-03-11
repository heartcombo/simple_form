module SimpleForm
  module Helpers
    module WrapperOptions
      private

      def merge_wrapper_options(options, context_options)
        options.merge(context_options) do |_, oldval, newval|
          if Array === oldval
            oldval + Array(newval)
          end
        end
      end
    end
  end
end
