module SimpleForm
  # A lot of configuration values are retrived from I18n,
  # like boolean collection, required string. This module provides
  # caching facility to speed up form construction.
  module I18nCache
    def i18n_cache(key)
      get_i18n_cache(key)[I18n.locale] ||= yield.freeze
    end

    def get_i18n_cache(key)
      instance_variable_get(:"@#{key}") || reset_i18n_cache(key)
    end

    def reset_i18n_cache(key)
      instance_variable_set(:"@#{key}", {})
    end
  end
end
