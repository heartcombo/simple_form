module MiscHelpers
  def store_translations(locale, translations, &block)
    begin
      I18n.backend.store_translations locale, translations
      yield
    ensure
      I18n.reload!
    end
  end

  def assert_no_select(selector, value = nil)
    assert_select(selector, :text => value, :count => 0)
  end

  def swap(object, new_values)
    old_values = {}
    new_values.each do |key, value|
      old_values[key] = object.send key
      object.send :"#{key}=", value
    end
    yield
  ensure
    old_values.each do |key, value|
      object.send :"#{key}=", value
    end
  end

  def with_concat_form_for(object, &block)
    concat simple_form_for(object, &block)
  end

  def with_concat_custom_form_for(object, &block)
    concat custom_form_for(object, &block)
  end

  def custom_form_for(object, *args, &block)
    simple_form_for(object, *(args << { :builder => CustomFormBuilder }), &block)
  end

  def custom_mapping_form_for(object, *args, &block)
    simple_form_for(object, *(args << { :builder => CustomMapTypeFormBuilder }), &block)
  end

  def with_concat_custom_mapping_form_for(object, &block)
    concat custom_mapping_form_for(object, &block)
  end
end

class CustomFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, *args, &block)
    super(attribute_name, *(args << { :input_html => { :class => 'custom' } }), &block)
  end
end

class CustomMapTypeFormBuilder < SimpleForm::FormBuilder
  map_type :custom_type, :to => SimpleForm::Inputs::StringInput
end
