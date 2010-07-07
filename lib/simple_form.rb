require 'action_view'
require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'

module SimpleForm
  autoload :Components,        'simple_form/components'
  autoload :ErrorNotification, 'simple_form/error_notification'
  autoload :FormBuilder,       'simple_form/form_builder'
  autoload :I18nCache,         'simple_form/i18n_cache'
  autoload :Inputs,            'simple_form/inputs'
  autoload :MapType,           'simple_form/map_type'

  # Default tag used on hints.
  mattr_accessor :hint_tag
  @@hint_tag = :span

  # Default tag used on errors.
  mattr_accessor :error_tag
  @@error_tag = :span

  # Method used to tidy up errors.
  mattr_accessor :error_method
  @@error_method = :first

  # Default tag used for error notification helper.
  mattr_accessor :error_notification_tag
  @@error_notification_tag = :p

  # Components used by the form builder.
  mattr_accessor :components
  @@components = [ :label_input, :hint, :error ]

  # Series of attemps to detect a default label method for collection.
  mattr_accessor :collection_label_methods
  @@collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection.
  mattr_accessor :collection_value_methods
  @@collection_value_methods = [ :id, :to_s ]

  # You can wrap all inputs in a pre-defined tag. Default is a div.
  mattr_accessor :wrapper_tag
  @@wrapper_tag = :div

  # You can define the class to use on all wrappers. Default is input.
  mattr_accessor :wrapper_class
  @@wrapper_class = :input

  # You can define the class to add to the wrapper when the field has errors. Default is fieldWithErrors.
  mattr_accessor :wrapper_error_class
  @@wrapper_error_class = :field_with_errors

  # How the label text should be generated altogether with the required text.
  mattr_accessor :label_text
  @@label_text = lambda { |label, required| "#{required} #{label}" }

  # Whether attributes are required by default (or not).
  mattr_accessor :required_by_default
  @@required_by_default = true

  # Collection of methods to detect if a file type was given.
  mattr_accessor :file_methods
  @@file_methods = [ :mounted_as, :file?, :public_filename ]

  # Default priority for time_zone inputs.
  mattr_accessor :time_zone_priority
  @@time_zone_priority = nil

  # Default priority for country inputs.
  mattr_accessor :country_priority
  @@country_priority = nil

  # Maximum size allowed for inputs.
  mattr_accessor :default_input_size
  @@default_input_size = 50

  # Default way to setup SimpleForm. Run rails generate simple_form:install
  # to create a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
