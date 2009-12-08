require 'rubygems'
require 'test/unit'
require 'i18n'

require 'action_controller'
require 'action_view/test_case'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

require File.join(File.dirname(__FILE__), '..', 'lib', 'simple_form')
I18n.default_locale = :en

class ActionView::TestCase
  include I18nHelper

  tests SimpleForm::FormHelper

  setup :set_controller
  setup :set_response
  setup :setup_new_user

  def set_controller
    @controller = MockController.new
  end

  def set_response
    @response = MockResponse.new(self)
  end

  def setup_new_user
    @user = User.new(
      :name => 'New in Simple Form!',
      :description => 'Hello!',
      :created_at => Time.now
    )
  end

  def protect_against_forgery?
    false
  end

  def user_path(*args)
    '/users'
  end
  alias :super_user_path :user_path
end
