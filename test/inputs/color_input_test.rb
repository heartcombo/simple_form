# frozen_string_literal: true

require 'test_helper'

class ColorInputTest < ActionView::TestCase
  test 'input generates a color field' do
    with_input_for @user, :favorite_color, :color
    assert_select 'input[type=color].color#user_favorite_color'
  end
end
