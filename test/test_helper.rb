require 'rubygems'
require 'bundler/setup'

require 'test/unit'
require 'mocha/setup'

require 'active_model'
require 'action_controller'
require 'action_view'
require 'action_view/template'

# Rails 3.0.4 is missing this "deprecation" require.
require 'active_support/core_ext/module/deprecation'
require 'action_view/test_case'

module Rails
  def self.env
    ActiveSupport::StringInquirer.new("test")
  end
end

$:.unshift File.expand_path("../../lib", __FILE__)
require 'simple_form'

require "rails/generators/test_case"
require 'generators/simple_form/install_generator'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each do |file|
  require file unless file.end_with?('discovery_inputs.rb')
end
I18n.default_locale = :en

require 'country_select'

ActionDispatch::Assertions::NO_STRIP << "label"

class ActionView::TestCase
  include MiscHelpers
  include SimpleForm::ActionViewExtensions::FormHelper

  setup :set_controller
  setup :setup_new_user

  def set_controller
    @controller = MockController.new
  end

  def setup_new_user(options={})
    @user = User.new({
      :id => 1,
      :name => 'New in SimpleForm!',
      :description => 'Hello!',
      :created_at => Time.now
    }.merge(options))

    @validating_user = ValidatingUser.new({
      :id => 1,
      :name => 'New in SimpleForm!',
      :description => 'Hello!',
      :home_picture => 'Home picture',
      :created_at => Time.now,
      :age => 19,
      :amount => 15,
      :attempts => 1,
      :company => [1]
    }.merge(options))

    @other_validating_user = OtherValidatingUser.new({
      :id => 1,
      :name => 'New in SimpleForm!',
      :description => 'Hello!',
      :created_at => Time.now,
      :age => 19,
      :company => 1
    }.merge(options))
  end

  def protect_against_forgery?
    false
  end

  def user_path(*args)
    '/users'
  end

  def company_user_path(*args)
    '/company/users'
  end

  alias :users_path :user_path
  alias :super_user_path :user_path
  alias :validating_user_path :user_path
  alias :validating_users_path :user_path
  alias :other_validating_user_path :user_path
end
