require 'test_helper'

class FormBuilderTest < ActionView::TestCase

  test 'input should generate a label with the text field' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_select 'form label[for=user_name]', 'Name'
  end

  test 'input should allow not using a label' do
    simple_form_for @user do |f|
      concat f.input :name, :label => false
    end
    assert_no_tag :tag => 'label'
  end

  test 'input should allow using a customized label' do
    simple_form_for @user do |f|
      concat f.input :name, :label => 'My label!'
    end
    assert_select 'form label[for=user_name]', 'My label!'
  end

  test 'input should use human attribute name if it responds to it' do
    @super_user = SuperUser.new
    simple_form_for @super_user do |f|
      concat f.input :name
    end
    assert_select 'form label[for=super_user_name]', 'Super User Name!'
  end

  test 'input should use i18n to pick up translation' do
    store_translations(:en, :views => { :labels => { :super_user => {
      :description => 'Descrição', :age => 'Idade'
    } } } ) do
      @super_user = SuperUser.new
      simple_form_for @super_user do |f|
        concat f.input :description
        concat f.input :age
      end
      assert_select 'form label[for=super_user_description]', 'Descrição'
      assert_select 'form label[for=super_user_age]', 'Idade'
    end
  end
end
