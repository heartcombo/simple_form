# frozen_string_literal: true
module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine, desc: 'Template engine to be invoked (erb, haml or slim).'
      class_option :bootstrap, type: :boolean, desc: 'Add the Bootstrap 5 wrappers to the SimpleForm initializer.'
      class_option :foundation, type: :boolean, desc: 'Add the Zurb Foundation 5 wrappers to the SimpleForm initializer.'
      class_option :css_zero, type: :boolean, desc: 'Add the CSS Zero wrappers to the SimpleForm initializer.'

      def info_bootstrap
        return if options.bootstrap? || options.foundation? || options.css_zero?
        puts "SimpleForm supports Bootstrap 5, Zurb Foundation 5 and CSS Zero. If you want "\
          "a configuration that is compatible with one of these frameworks, then please " \
          "re-run this generator with --bootstrap, --foundation or --css-zero as an option."
      end

      def copy_config
        template "config/initializers/simple_form.rb"

        if options[:bootstrap]
          template "config/initializers/simple_form_bootstrap.rb"
        elsif options[:css_zero]
          template "config/initializers/simple_form_css_zero.rb"
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
        if behavior == :invoke && options.bootstrap?
          readme "README"
        end
      end
    end
  end
end
