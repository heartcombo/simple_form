require 'rubygems'
require 'test/unit'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'
require 'action_view/test_case'

begin
  require 'ruby-debug'
rescue LoadError
end

$:.unshift File.join(File.dirname(__FILE__), '..', 'lib', 'simple_form')
require 'simple_form'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each { |f| require f }
I18n.default_locale = :en

country_select = "#{File.dirname(__FILE__)}/support/country_select/lib"

if File.exists?(country_select)
  $:.unshift country_select
  require 'country_select'
else
  raise "Could not find country_select plugin in test/support. Please execute git submodule update --init."
end

class SimpleForm::FormBuilder
  attr_accessor :attribute_name, :column, :reflection, :input_type, :options
end

class ActionView::TestCase
  include MiscHelpers

  tests SimpleForm::ActionViewExtensions::FormHelper

  setup :set_controller
  setup :set_response
  setup :setup_new_user

  def set_controller
    @controller = MockController.new
  end

  def set_response
    @response = MockResponse.new(self)
  end

  def setup_new_user(options={})
    @user = User.new({
      :id => 1,
      :name => 'New in Simple Form!',
      :description => 'Hello!',
      :created_at => Time.now
    }.merge(options))
    
    @validating_user = ValidatingUser.new({
      :id => 1,
      :name => 'New in Simple Form!',
      :description => 'Hello!',
      :created_at => Time.now
    }.merge(options))
  end

  def protect_against_forgery?
    false
  end

  def user_path(*args)
    '/users'
  end
  alias :users_path :user_path
  alias :super_user_path :user_path
  alias :validating_user_path :user_path
end
