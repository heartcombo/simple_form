require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'

module SimpleForm
  autoload :Components,  'simple_form/components'
  autoload :FormBuilder, 'simple_form/form_builder'
  autoload :I18nCache,   'simple_form/i18n_cache'
  autoload :MapType,     'simple_form/map_type'
  autoload :RequiredComponent, 'simple_form/required_component'
end