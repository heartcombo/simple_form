module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      class_option :template_engine, :desc => 'Template engine to be invoked (erb, haml or slim).'
      class_option :bootstrap, :type => :boolean, :desc => 'Add the Twitter Bootstrap wrappers to the SimpleForm initializer.'
      class_option :zurb_foundation, :type => :boolean, :desc => 'Add the Zurb Foundation wrappers to the SimpleForm initializer.'

      def info_bootstrap
        return if options.bootstrap? || options.zurb_foundation?
        puts "SimpleForm 2 supports both Twitter bootstrap and Zurb Foundation. In case you want to " \
          "generate bootstrap or zurb configuration, please re-run this " \
          "generator passing either --bootstrap or --zurb_foundation as option."
      end

      def copy_config
        directory 'config'
				if options.zurb_foundation?
					directory 'lib'
				end
      end

      def copy_scaffold_template
        engine = options[:template_engine]
        copy_file "_form.html.#{engine}", "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
      end

      def show_readme
        if behavior == :invoke && options.bootstrap?
          readme "README"
        elsif behavior == :invoke && options.zurb_foundation?
          readme "ZURB_README"
        end
      end
    end
  end
end
