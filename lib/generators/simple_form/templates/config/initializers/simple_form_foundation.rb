# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  config.wrappers :foundation, :tag => 'div', :class => 'form-field', :error_class => 'error' do |b|
    b.use :html5
    b.use :label_input
    b.use :placeholder
    b.use :error, :wrap_with => { :tag => 'small' }
    b.use :hint,  :wrap_with => { :tag => 'span', :class => 'hint' }
  end

  config.button_class = 'button nice'
  config.default_wrapper = :foundation
  config.error_notification_class = 'alert-box error'
  config.form_class = 'nice'
  config.label_class = nil

end

class StringInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push 'input-text'
  end
end

class PasswordInput < SimpleForm::Inputs::PasswordInput
  def input_html_classes
    super.push 'input-text'
  end
end

