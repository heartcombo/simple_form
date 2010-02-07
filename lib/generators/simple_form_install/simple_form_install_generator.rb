class SimpleFormInstallGenerator < Rails::Generators::Base
  desc "Copy SimpleForm default files"

  def self.source_root
    @_source_root = File.expand_path('../templates', __FILE__)
  end

  def copy_initializers
    copy_file 'simple_form.rb', 'config/initializers/simple_form.rb'
  end

  def copy_locale_file
    copy_file 'en.yml', 'config/locales/simple_form.en.yml'
  end

  def copy_scaffold_template
    copy_file '_form.html.erb', 'lib/templates/erb/scaffold/_form.html.erb'
  end
end
