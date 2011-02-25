require "simple_form"

class CustomBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options={}, &block)
    super(attribute_name, options, &block)
  end
end