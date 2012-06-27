require File.expand_path('../utilities', __FILE__)

module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include SimpleForm::Generators::Utilities
      extend  SimpleForm::Generators::Utilities

      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option  :template_engine, :aliases => '-e',
                    :desc => "Template engine to be invoked, supported: #{frameworks.join(', ')}.",
                    :type => :string
      class_option  :template_framework, :aliases => '-b',
                    :desc => "Framework to be invoked, supported: #{engines.join(', ')}.",
                    :type => :string

      def info
        unless options[:template_framework]
          say "SimpleForm supports:"
          say "#{frameworks.join(', ')}"
          say 'to install a framework specifiy (--template_framework || -b) framework'
        end
      end

      # TODO: exit on any errors as it doesn't make sense to continue.
      def error
        if options[:template_framework] && !is_framework?(options[:template_framework])
          say "SimpleForm doesn't support the framework: #{options[:template_framework]}"
        end

        if options[:template_engine] && !is_engine?(options[:template_engine])
          say "SimpleForm doesn't support the engine: #{options[:template_engine]}"
        end
      end

      def copy_config
        template "config/initializers/simple_form.rb"

        if options[:template_framework] && is_framework?(options[:template_framework])
          template "config/initializers/simple_form_#{options[:template_framework]}.rb"
        end

        directory 'config/locales'
      end

      def copy_scaffold_template
       if is_engine?(options[:template_engine])
          copy_file "_form.html.#{options[:template_engine]}", "lib/templates/#{options[:template_engine]}/scaffold/_form.html.#{options[:template_engine]}"
        end
      end

      def show_readme
        if behavior == :invoke && is_framework?(options[:template_framework])
          readme "#{options[:template_framework]}.txt"
        end
      end
    end
  end
end
