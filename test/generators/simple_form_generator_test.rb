require 'test_helper'

class SimpleFormGeneratorTest < Rails::Generators::TestCase
  tests SimpleForm::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __FILE__)
  setup :prepare_destination
  teardown { rm_rf(destination_root) }

  test 'generates example locale file' do
    run_generator
    assert_file 'config/locales/simple_form.en.yml'
  end

  test 'generates the simple_form initializer' do
    run_generator
    assert_file 'config/initializers/simple_form.rb',
      /config\.default_wrapper = :default/, /config\.boolean_style = :nested/
  end

  test 'generates the simple_form initializer with the bootstrap wrappers' do
    run_generator %w(--bootstrap)
    assert_file 'config/initializers/simple_form.rb', /config\.wrappers :bootstrap/,
      /config\.default_wrapper = :bootstrap/
  end

	test 'generates the simple_form initializer with the zurb_foundation wrappers' do
    run_generator %w(--zurb_foundation)
    assert_file 'config/initializers/simple_form.rb', /config\.wrappers :zurb/,
      /config\.default_wrapper = :zurb/
	end

	test 'generates the simple_form initializer with core_ext loaer' do
    run_generator %w(--zurb_foundation)
    assert_file 'config/initializers/simple_form.rb', /Dir[Rails.root.join("lib\/core_ext\/simple_form\/**\/*.rb")].each { |f| require f }/
	end

	test 'generates the simple_form initializer with nice form class' do
    run_generator %w(--zurb_foundation)
    assert_file 'config/initializers/simple_form.rb', /config.form_class = :nice/
	end

	test 'generates the simple_form initializer with nice button class' do
    run_generator %w(--zurb_foundation)
    assert_file 'config/initializers/simple_form.rb', /config.button_class = 'nice button'/
	end

	test 'generates the lib core ext classes for password for zurb_foundation' do
		run_generator %w(--zurb_foundation)
		assert_file 'lib/core_ext/simple_form/inputs/password_input.rb'
	end 

	test 'generates the lib core ext classes for strings for zurb_foundation' do
		run_generator %w(--zurb_foundation)
		assert_file 'lib/core_ext/simple_form/inputs/string_input.rb'
	end 

  %W(erb haml slim).each do |engine|
    test "generates the scaffold template when using #{engine}" do
      run_generator ['-e', engine]
      assert_file "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
    end
  end
end
