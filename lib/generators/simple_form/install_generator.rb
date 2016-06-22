module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine, desc: 'Template engine to be invoked (erb, haml or slim).'
      class_option :bootstrap, type: :boolean, desc: 'Add the Bootstrap 3 wrappers to the SimpleForm initializer.'
      class_option :bootstrap4, type: :boolean, desc: 'Add the Bootstrap 4 wrappers to the SimpleForm initializer.'
      class_option :foundation, type: :boolean, desc: 'Add the Zurb Foundation 5 wrappers to the SimpleForm initializer.'

      def info_bootstrap
        return if options.bootstrap? || options.foundation?
        puts "SimpleForm 3 supports Bootstrap 3, 4 and Zurb Foundation 5. If you want "\
          "a configuration that is compatible with one of these frameworks, then please " \
          "re-run this generator with --bootstrap, --bootstrap4 or --foundation as an option."
      end

      def copy_config
        template "config/initializers/simple_form.rb"

        if options[:bootstrap]
          template "config/initializers/simple_form_bootstrap3.rb"
        elsif options[:bootstrap4]
          template "config/initializers/simple_form_bootstrap4.rb"
        elsif options[:foundation]
          template "config/initializers/simple_form_foundation.rb"
        end

        directory 'config/locales'
      end

      def copy_scaffold_template
        engine = options[:template_engine]
        copy_file "_form.html.#{engine}", "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
      end

      def show_readme
        if behavior == :invoke
          case options
          when :bootstrap  then readme "README_bootstrap3"
          when :bootstrap4 then readme "README_bootstrap4"
          end
        end
      end
    end
  end
end
