class StringInput < SimpleForm::Inputs::StringInput
  def input
    "<section>#{super}</section>".html_safe
  end
end

class NumericInput < SimpleForm::Inputs::NumericInput
  def input
    "<section>#{super}</section>".html_safe
  end
end

class CustomizedInput < SimpleForm::Inputs::StringInput
  def input
    "<section>#{super}</section>".html_safe
  end

  def input_method
    :text_field
  end
end

class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_classes
    super.push('chosen')
  end
end
