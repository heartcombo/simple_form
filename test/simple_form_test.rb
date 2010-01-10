require 'test_helper'

class SimpleFormTest < ActiveSupport::TestCase
  test 'setup block yields self' do
    SimpleForm.setup do |config|
      assert_equal SimpleForm, config
    end
  end
end
