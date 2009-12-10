require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'

module SimpleForm
  autoload :Components,      'simple_form/components'
  autoload :FormBuilder,     'simple_form/form_builder'
  autoload :I18nCache,       'simple_form/i18n_cache'
  autoload :MapType,         'simple_form/map_type'
  autoload :RequiredHelpers, 'simple_form/required_helpers'

  # Default tag used in componenents.
  mattr_accessor :component_tag
  @@component_tag = :span

  # Components used by the form builder.
  mattr_accessor :components
  @@components = [
    SimpleForm::Components::Label, SimpleForm::Components::Input,
    SimpleForm::Components::Hint,  SimpleForm::Components::Error
  ]
end