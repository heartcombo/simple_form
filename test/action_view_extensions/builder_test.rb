require 'test_helper'

class BuilderTest < ActionView::TestCase
  test 'collection radio accepts a collection and generate inputs from value method' do
    form_for @user do |f|
      concat f.collection_radio :active, [true, false], :to_s, :to_s
    end

    assert_select 'form input[type=radio][value=true]#user_active_true'
    assert_select 'form label[for=user_active_true]', 'true'

    assert_select 'form input[type=radio][value=false]#user_active_false'
    assert_select 'form label[for=user_active_false]', 'false'
  end

  test 'collection radio accepts a collection and generate inputs from label method' do
    form_for @user do |f|
      concat f.collection_radio :active, [true, false], :to_s, :to_s
    end

    assert_select 'form label[for=user_active_true]', 'true'
    assert_select 'form label[for=user_active_false]', 'false'
  end

  test 'collection radio accepts html options as input' do
    form_for @user do |f|
      concat f.collection_radio :active, [[1, true], [0, false]], :last, :first, :class => 'radio'
    end

    assert_select 'form input[type=radio][value=true].radio#user_active_true'
    assert_select 'form input[type=radio][value=false].radio#user_active_false'
  end

  test 'simple fields for is available and yields an instance of FormBuilder' do
    form_for @user do |f|
      f.simple_fields_for :posts do |posts_form|
        assert posts_form.instance_of?(SimpleForm::FormBuilder)
      end
    end
  end
end
