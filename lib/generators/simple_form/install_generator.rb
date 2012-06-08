module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine,  :desc => 'Template engine to be invoked (erb, haml or slim).'
      class_option :framework,        :desc => 'Framework to set defaults wrapper for (bootstrap, foundation)',
                                      :type => :string

      def info_template
        return if options[:framework]
        puts  "SimpleForm supports the following frameworks: " \
              "Twitter - [bootstrap] " \
              "Zurb - [foundation]. " \
              "To generate re-run this generator passing: " \
              "--framework [name] as an option"
      end

      def copy_config
        template "config/initializers/simple_form.rb"

        if options[:framework]
          template "config/initializers/simple_form_#{options[:framework]}.rb"
        end

        directory 'config/locales'
      end

      def copy_scaffold_template
        engine = options[:template_engine]
        copy_file "_form.html.#{engine}", "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
      end

      def show_readme
        if behavior == :invoke && options[:framework]
          readme "#{options[:framework]}.txt"
        end
      end
    end
  end
end
