class SimpleFormInstallGenerator < Rails::Generators::Base
  def copy_initializers
    template 'simple_form.rb', 'config/initializers/simple_form.rb'
  end

  def copy_locale_file
    template '../../locale/en.yml', 'config/locales/simple_form.en.yml'
  end
end
