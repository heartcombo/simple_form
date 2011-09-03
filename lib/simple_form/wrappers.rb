module SimpleForm
  module Wrappers
    autoload :Builder,   'simple_form/wrappers/builder'
    autoload :Many,      'simple_form/wrappers/many'
    autoload :Root,      'simple_form/wrappers/root'
    autoload :Single,    'simple_form/wrappers/single'

    def self.find(name)
      SimpleForm.wrapper.find(name) || SingleForm::Wrappers::Many.new(name, [name])
    end
  end
end