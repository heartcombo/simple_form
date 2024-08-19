# frozen_string_literal: true
require 'rails/railtie'

module SimpleForm
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << SimpleForm

    config.after_initialize do
      unless SimpleForm.configured?
        warn '[Simple Form] Simple Form is not configured in the application and will use the default values.' +
          ' Use `rails generate simple_form:install` to generate the Simple Form configuration.'
      end
    end

    initializer "simple_form.deprecator" do |app|
      app.deprecators[:simple_form] = SimpleForm.deprecator if app.respond_to?(:deprecators)
    end
  end
end
