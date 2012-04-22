require 'test_helper'

class DiscoveryTest < ActionView::TestCase
  # Setup new inputs and remove them after the test.
  def discovery(value=false)
    swap SimpleForm, :cache_discovery => value do
      begin
        load "support/discovery_inputs.rb"
        yield
      ensure
        SimpleForm::FormBuilder.discovery_cache.clear
        Object.send :remove_const, :StringInput
        Object.send :remove_const, :NumericInput
        Object.send :remove_const, :CustomizedInput
        Object.send :remove_const, :CollectionSelectInput
      end
    end
  end

  test 'builder should not discover new inputs if cached' do
    with_form_for @user, :name
    assert_select 'form input#user_name.string'

    discovery(true) do
      with_form_for @user, :name
      assert_no_select 'form section input#user_name.string'
    end
  end

  test 'builder should discover new inputs' do
    discovery do
      with_form_for @user, :name, :as => :customized
      assert_select 'form section input#user_name.string'
    end
  end

  test 'builder should not discover new inputs if discovery is off' do
    with_form_for @user, :name
    assert_select 'form input#user_name.string'

    swap SimpleForm, :inputs_discovery => false do
      discovery do
        with_form_for @user, :name
        assert_no_select 'form section input#user_name.string'
      end
    end
  end

  test 'builder should discover new inputs from mappings if not cached' do
    discovery do
      with_form_for @user, :name
      assert_select 'form section input#user_name.string'
    end
  end

  test 'builder should discover new inputs from internal fallbacks if not cached' do
    discovery do
      with_form_for @user, :age
      assert_select 'form section input#user_age.numeric.integer'
    end
  end

  test 'new inputs can override the input_html_options' do
    discovery do
      with_form_for @user, :active, :as => :select
      assert_select 'form select#user_active.select.chosen'
    end
  end
end
