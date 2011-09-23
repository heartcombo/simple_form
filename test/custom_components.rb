module Div
  def div
    template.content_tag(:div, 'Custom Component', :class => 'custom_input')
  end
end

SimpleForm::Inputs::Base.send(:include, Div)
