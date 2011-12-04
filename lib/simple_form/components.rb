module SimpleForm
  # Components are a special type of helpers that can work on their own.
  # For example, by using a component, it will automatically change the
  # output under given circunstences without user input. For example,
  # the disabled helper always need a :disabled => true option given
  # to the input in order to be enabled. On the other hand, things like
  # hint can generate output automatically by doing I18n lookups.
  module Components
    autoload :Errors,       'simple_form/components/errors'
    autoload :Hints,        'simple_form/components/hints'
    autoload :LabelInput,   'simple_form/components/label_input'
    autoload :Labels,       'simple_form/components/labels'
    autoload :Maxlength,    'simple_form/components/maxlength'
    autoload :Pattern,      'simple_form/components/pattern'
    autoload :Placeholders, 'simple_form/components/placeholders'
    autoload :Required,     'simple_form/components/required'
  end
end
