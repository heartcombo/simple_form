require 'rubygems'
require 'test/unit'

require 'action_controller'
require 'action_view/test_case'

require File.join(File.dirname(__FILE__), '..', 'lib', 'simple_form')

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

class ActionView::TestCase
  setup :set_controller
  setup :set_response

  def set_controller
    @controller = MockController.new
  end

  def set_response
    @response = MockResponse.new(self)
  end

  def protect_against_forgery?
    false
  end
end
