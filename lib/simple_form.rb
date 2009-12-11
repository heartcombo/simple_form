require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'

module SimpleForm
  autoload :Components,      'simple_form/components'
  autoload :FormBuilder,     'simple_form/form_builder'
  autoload :I18nCache,       'simple_form/i18n_cache'
  autoload :MapType,         'simple_form/map_type'
  autoload :RequiredHelpers, 'simple_form/required_helpers'

  # Default tag used in components.
  mattr_accessor :component_tag
  @@component_tag = :span

  # Components used by the form builder.
  mattr_accessor :components
  @@components = [
    SimpleForm::Components::Wrapper, SimpleForm::Components::Label,
    SimpleForm::Components::Input, SimpleForm::Components::Hint,
    SimpleForm::Components::Error
  ]

  # Series of attemps to detect a default label method for collection
  mattr_accessor :collection_label_methods
  @@collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection
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
  @@file_methods = [ :file?, :public_filename ]

  # Default priority for time_zone inputs.
  mattr_accessor :time_zone_priority
  @@time_zone_priority = nil

  # Default priority for country inputs.
  mattr_accessor :country_priority
  @@country_priority = nil
end
