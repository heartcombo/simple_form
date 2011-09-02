module SimpleForm
  module Wrappers
    autoload :Many,      'simple_form/wrappers/many'
    autoload :Root,      'simple_form/wrappers/root'
    autoload :Single,    'simple_form/wrappers/single'

    def self.find(name)
      SimpleForm.components.find { |c| c.namespace == name } || SingleForm::Wrappers::Anonym.new(name)
    end

    def self.wrap(array)
      array.map do |item|
        case item
        when :error
          Single.new(:error, :tag => SimpleForm.error_tag, :class => SimpleForm.error_class)
        else
          item
        end
      end
    end
  end
end