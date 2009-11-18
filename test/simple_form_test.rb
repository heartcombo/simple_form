require 'test_helper'

class MockController

  def url_for(*args)
    "http://example.com"
  end
end

class MockResponse

  def initialize(test_case)
    @test_case = test_case
  end

  def content_type
    'text/html'
  end

  def body
    @test_case.send :output_buffer
  end
end

class SimpleFormTest < ActionView::TestCase
  tests SimpleForm::FormHelper

  def protect_against_forgery?
    false
  end

  def setup
    @controller = MockController.new
    @response = MockResponse.new(self)
  end

  test 'yields an instance of FormBuilder' do
    simple_form_for :product do |f|
      assert f.instance_of?(SimpleForm::FormBuilder)
    end
  end

  test 'pass options to simple form' do
    simple_form_for :product, :url => '/products', :html => { :id => 'my_form' } do |f| end
    assert_select 'form#my_form'
    assert_select 'form[action=/products]'
  end
end
