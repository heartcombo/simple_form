module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine, :desc => 'Template engine to be invoked (erb, haml or slim).'
      class_option :bootstrap, :type => :boolean, :desc => 'Add the Twitter Bootstrap wrappers to the SimpleForm initializer.'

      def info_bootstrap
        return if options.bootstrap?
        puts "SimpleForm 2 supports Twitter bootstrap. In case you want to " \
          "generate bootstrap configuration, please re-run this " \
          "generator passing --bootstrap as option."
      end

      def copy_config
        directory 'config'
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
