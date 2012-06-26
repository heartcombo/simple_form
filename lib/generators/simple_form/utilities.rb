module SimpleForm
  module Generators
    module Utilities
      ENGINE_PARTIAL_DIR        = File.expand_path('../templates', __FILE__)
      FRAMEWORK_INITIALIZER_DIR = File.expand_path('../templates/config/initializers', __FILE__)

      # An array of supported frameworks.
      def frameworks
        Dir["#{FRAMEWORK_INITIALIZER_DIR}/simple_form_*.rb"].map! do |i|
          File.basename(i, '.rb').gsub!('simple_form_', '')
        end
      end

      # Validate #{framework}
      def is_framework?(framework)
        File.exists?("#{FRAMEWORK_INITIALIZER_DIR}/simple_form_#{framework}.rb")
      end

      # An array of supported engines.
      def engines
        Dir["#{ENGINE_PARTIAL_DIR}/_form.html.*"].map! do |p|
          File.basename(p).gsub!('_form.html.', '')
        end
      end

      # Validate #{engine}
      def is_engine?(engine)
        File.exists?("#{ENGINE_PARTIAL_DIR}/_form.html.#{engine}")
      end
    end
  end
end