module SimpleForm
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file 'simple_form.rb', 'config/initializers/simple_form.rb'
      end

      def copy_locale_file
        copy_file 'en.yml', 'config/locales/simple_form.en.yml'
      end

      def copy_scaffold_template
        if Rails::Generators.options[:rails][:template_engine] == :haml
          copy_file '_form.html.haml', 'lib/templates/haml/scaffold/_form.html.haml'
        else
          copy_file '_form.html.erb', 'lib/templates/erb/scaffold/_form.html.erb'
        end
      end
    end
  end
end