module SimpleForm
  module Wrappers
    autoload :Many,      'simple_form/wrappers/many'
    autoload :Root,      'simple_form/wrappers/root'
    autoload :Single,    'simple_form/wrappers/single'
    autoload :Anonym,    'simple_form/wrappers/anonym'

    # TODO: Test the anonym case
    def self.find(name)
      SimpleForm.components.find { |c| c.namespace == name } || SingleForm::Wrappers::Anonym.new(name)
    end

    def self.wrap(array)
      array.map do |item|
        case item
        when :error
          Single.new(:error, :tag => SimpleForm.error_tag, :class => SimpleForm.error_class)
        when :hint
          Single.new(:hint,  :tag => SimpleForm.hint_tag,  :class => SimpleForm.hint_class)
        else
          item
        end
      end
    end
  end
end