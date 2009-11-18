#ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'test/unit'

require 'action_controller'
require 'action_view/test_case'

require File.join(File.dirname(__FILE__), '..', 'lib', 'simple_form')

#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

#ActionController::Base.logger = nil
#ActionController::Routing::Routes.reload rescue nil
#ActionController::Base.session_store = nil

#FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
#ActionView::Base.cache_template_loading = true
#ActionController::Base.view_paths = FIXTURE_LOAD_PATH


#class ActiveSupport::TestCase
#  self.use_transactional_fixtures = true
#  self.use_instantiated_fixtures  = false
#end
