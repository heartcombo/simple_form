# frozen_string_literal: true
module SimpleForm
  # A lot of configuration values are retrived from I18n,
  # like boolean collection, required string. This module provides
  # caching facility to speed up form construction.
  module I18nCache
    def i18n_cache(key)
      store = I18nCacheStore.instance
      store[key] ||= {}
      store[key][I18n.locale] ||= yield.freeze
    end

    def reset_i18n_cache(key)
      I18nCacheStore.instance[key] = {}
    end
  end

  class I18nCacheStore
    include Singleton

    def initialize
      @store ||= {}
    end

    def [](key)
      @store[key]
    end

    def []=(key, value)
      @store[key] = value
    end
  end
end
