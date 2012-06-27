module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      attr_accessor :engine, :framework

      ENGINES     = %w(erb haml slim)
      FRAMEWORKS  = %w(bootstrap foundation)

      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option  :template_engine, :aliases => '-e',
                    :desc => "Template engine to be invoked, supported: #{FRAMEWORKS.join(', ')}.",
                    :type => :string
      class_option  :framework, :aliases => '-b',
                    :desc => "Framework to be invoked, supported: #{ENGINES.join(', ')}.",
                    :type => :string

      def iniitialize
        self.engine    = options[:template_engine]
        self.framework = options[:framework]
      end

      def info
        unless framework
          say 'SimpleForm supports:'
          say "#{FRAMEWORKS.join(', ')}"
          say 'to install a framework specifiy'
          say '(--framework || -b) framework'

          unless FRAMEWORKS.include?(framework)
            say 'SimpleForm does not support'
            say "the framework named: #{framework}"
          end
        end

        unless ENGINES.include?(engine)
          say 'SimpleForm does not support'
          say "the template engine named: #{engine}"
        end
      end

      def copy_config
        template "config/initializers/simple_form.rb"

        if FRAMEWORKS.include?(framework)
          template "config/initializers/simple_form_#{framework}.rb"
        end

        directory 'config/locales'
      end

      def copy_scaffold_template
        if ENGINES.include?(engine)
          copy_file "_form.html.#{engine}", "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
        end
      end

      def show_readme
        if behavior == :invoke && FRAMEWORKS.include?(framework)
          readme "#{framework}.txt"
        end
      end
    end
  end
end
