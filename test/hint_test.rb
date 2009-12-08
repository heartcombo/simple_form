require 'test_helper'

class ErrorTest < ActionView::TestCase

  test 'input should allow generating a hint' do
    simple_form_for @user do |f|
      concat f.input :name, :hint => 'Use with care...'
    end
    assert_select 'form span.hint', 'Use with care...'
  end

  test 'input should not generate a hint by default' do
    simple_form_for @user do |f|
      concat f.input :name
    end
    assert_no_select 'form span.hint'
  end
end
