require 'test_helper'

class ErrorTest < ActionView::TestCase

  test 'input should allow generating a hint' do
    simple_form_for @user do |f|
      concat f.input :name, :hint => 'Use with care...'
    end
    puts output_buffer
    assert_select 'form span.hint', 'Use with care...'
  end
end
