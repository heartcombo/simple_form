require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'
require 'simple_form/action_view_extensions/instance_tag'

module SimpleForm
  autoload :Components,  'simple_form/components'
  autoload :FormBuilder, 'simple_form/form_builder'
  autoload :I18nCache,   'simple_form/i18n_cache'
  autoload :Inputs,      'simple_form/inputs'
  autoload :MapType,     'simple_form/map_type'

  # Default tag used on hints.
  mattr_accessor :hint_tag
  @@hint_tag = :span

  # Default tag used on errors.
  mattr_accessor :error_tag
  @@error_tag = :span

  # Components used by the form builder.
  mattr_accessor :components
  @@components = [ :label, :input, :hint, :error ]

  # Series of attemps to detect a default label method for collection.
  mattr_accessor :collection_label_methods
  @@collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection.
  mattr_accessor :collection_value_methods
  @@collection_value_methods = [ :id, :to_s ]

  # You can wrap all inputs in a pre-defined tag. By default is nil.
  mattr_accessor :wrapper_tag
  @@wrapper_tag = nil

  # How the label text should be generated altogether with the required text.
  mattr_accessor :label_text
  @@label_text = lambda { |label, required| "#{required} #{label}" }

  # Collection of methods to detect if a file type was given.
  mattr_accessor :file_methods
  @@file_methods = [ :mounted_as, :file?, :public_filename ]

  # Default priority for time_zone inputs.
  mattr_accessor :time_zone_priority
  @@time_zone_priority = nil

  # Default priority for country inputs.
  mattr_accessor :country_priority
  @@country_priority = nil

  # Default way to setup SimpleForm. Run script/generate simple_form_install
  # to create a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
