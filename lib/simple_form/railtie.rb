require 'rails/railtie'

module SimpleForm
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << SimpleForm
  end
end
