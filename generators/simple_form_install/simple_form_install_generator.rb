class SimpleFormInstallGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.template  'simple_form.rb', 'config/initializers/simple_form.rb'

      m.directory 'config/locales'
      m.template  locale_file, 'config/locales/simple_form.yml'
    end
  end

  private

    def locale_file
      @locale_file ||= '../../../lib/simple_form/locale/en.yml'
    end

end
