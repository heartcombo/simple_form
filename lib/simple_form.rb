require 'action_view'
require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'

module SimpleForm
  autoload :Components,        'simple_form/components'
  autoload :ErrorNotification, 'simple_form/error_notification'
  autoload :FormBuilder,       'simple_form/form_builder'
  autoload :Helpers,           'simple_form/helpers'
  autoload :I18nCache,         'simple_form/i18n_cache'
  autoload :Inputs,            'simple_form/inputs'
  autoload :MapType,           'simple_form/map_type'

  # Default tag used on hints.
  mattr_accessor :hint_tag
  @@hint_tag = :span

  # CSS class to add to all hint tags.
  mattr_accessor :hint_class
  @@hint_class = :hint

  # Default tag used on errors.
  mattr_accessor :error_tag
  @@error_tag = :span

  # CSS class to add to all error tags.
  mattr_accessor :error_class
  @@error_class = :error

  # Method used to tidy up errors.
  mattr_accessor :error_method
  @@error_method = :first

  # Default tag used for error notification helper.
  mattr_accessor :error_notification_tag
  @@error_notification_tag = :p

  # CSS class to add for error notification helper.
  mattr_accessor :error_notification_class
  @@error_notification_class = :error_notification

  # ID to add for error notification helper.
  mattr_accessor :error_notification_id
  @@error_notification_id = nil

  # Components used by the form builder.
  mattr_accessor :components
  @@components = [ :placeholder, :label_input, :hint, :error ]

  # Series of attemps to detect a default label method for collection.
  mattr_accessor :collection_label_methods
  @@collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection.
  mattr_accessor :collection_value_methods
  @@collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  mattr_accessor :collection_wrapper_tag
  @@collection_wrapper_tag = nil

  # You can wrap each item in a collection of radio/check boxes with a tag, defaulting to none.
  mattr_accessor :item_wrapper_tag
  @@item_wrapper_tag = :span

  # You can wrap all inputs in a pre-defined tag. Default is a div.
  mattr_accessor :wrapper_tag
  @@wrapper_tag = :div

  # You can define the class to use on all wrappers. Default is input.
  mattr_accessor :wrapper_class
  @@wrapper_class = :input

  # You can define the class to add to the wrapper when the field has errors. Default is field_with_errors.
  mattr_accessor :wrapper_error_class
  @@wrapper_error_class = :field_with_errors

  # How the label text should be generated altogether with the required text.
  mattr_accessor :label_text
  @@label_text = lambda { |label, required| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  mattr_accessor :label_class
  @@label_class = nil

  # You can define the class to use on all forms. Default is simple_form.
  mattr_accessor :form_class
  @@form_class = :simple_form

  # Whether attributes are required by default (or not).
  mattr_accessor :required_by_default
  @@required_by_default = true

  # Tell browsers whether to use default HTML5 validations (novalidate option).
  mattr_accessor :browser_validations
  @@browser_validations = true

  # Determines whether HTML5 types (:email, :url, :search, :tel) and attributes
  # (e.g. required) are used or not. True by default.
  # Having this on in non-HTML5 compliant sites can cause odd behavior in
  # HTML5-aware browsers such as Chrome.
  mattr_accessor :html5
  @@html5 = true

  # Collection of methods to detect if a file type was given.
  mattr_accessor :file_methods
  @@file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value, such as { /count/ => :integer }.
  mattr_accessor :input_mappings
  @@input_mappings = nil

  # Default priority for time_zone inputs.
  mattr_accessor :time_zone_priority
  @@time_zone_priority = nil

  # Default priority for country inputs.
  mattr_accessor :country_priority
  @@country_priority = nil

  # Maximum size allowed for inputs.
  mattr_accessor :default_input_size
  @@default_input_size = 50

  # When off, do not use translations in hint, labels and placeholders.
  # It is a small performance improvement if you are not using such features.
  mattr_accessor :translate
  @@translate = true

  # Automatically discover new inputs in Rails' autoload path.
  mattr_accessor :inputs_discovery
  @@inputs_discovery = true

  # Cache simple form inputs discovery
  mattr_accessor :cache_discovery
  @@cache_discovery = !Rails.env.development?

  # Default way to setup SimpleForm. Run rails generate simple_form:install
  # to create a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
