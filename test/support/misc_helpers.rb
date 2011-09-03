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

  def custom_wrapper
    SimpleForm.build :tag => :section, :class => "custom_wrapper" do |b|
      b.use :another, :tag => :div, :class => "another_wrapper" do |ba|
        ba.use :label
        ba.use :input
      end
      b.use :error_wrapper, :tag => :div, :class => "error_wrapper" do |be|
        be.use :error, :tag => :span, :class => "omg_error"
      end
      b.use :hint, :tag => :span, :class => "omg_hint"
    end
  end

  # Temporary hack to deal with components.
  # TODO: Remove this and tests that uses this once we remove components
  def swap!(*args)
    swap(*args) do
      SimpleForm.deprecated_components = [ :placeholder, :label_input, :hint, :error ]
      yield
    end
  ensure
    SimpleForm.deprecated_components = [ :placeholder, :label_input, :hint, :error ]
  end

  def custom_form_for(object, *args, &block)
    simple_form_for(object, *(args << { :builder => CustomFormBuilder }), &block)
  end

  def custom_mapping_form_for(object, *args, &block)
    simple_form_for(object, *(args << { :builder => CustomMapTypeFormBuilder }), &block)
  end

  def with_concat_form_for(object, &block)
    concat simple_form_for(object, &block)
  end

  def with_concat_custom_form_for(object, &block)
    concat custom_form_for(object, &block)
  end

  def with_concat_custom_mapping_form_for(object, &block)
    concat custom_mapping_form_for(object, &block)
  end

  def with_form_for(object, *args, &block)
    with_concat_form_for(object) do |f|
      f.input(*args, &block)
    end
  end

  def with_input_for(object, attribute_name, type, options={})
    with_concat_form_for(object) do |f|
      f.input(attribute_name, options.merge(:as => type))
    end
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
