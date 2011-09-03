module SimpleForm
  module Wrappers
    autoload :Many,      'simple_form/wrappers/many'
    autoload :Root,      'simple_form/wrappers/root'
    autoload :Single,    'simple_form/wrappers/single'

    # TODO: Test the many case
    def self.find(name)
      SimpleForm.components.find { |c| c.to_sym == name } || SingleForm::Wrappers::Many.new(name, [name])
    end

    def self.wrap(array)
      Root.new(
        array.map do |item|
          case item
          when :error
            Single.new(:error, :tag => SimpleForm.error_tag, :class => SimpleForm.error_class)
          when :hint
            Single.new(:hint,  :tag => SimpleForm.hint_tag,  :class => SimpleForm.hint_class)
          else
            item
          end
        end,
        :tag => SimpleForm.wrapper_tag,
        :class => SimpleForm.wrapper_class,
        :error_class => SimpleForm.wrapper_error_class
      )
    end
  end
end