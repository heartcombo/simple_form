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

  %W(bootstrap foundation).each do |framework|
    test "generates the simple_form initializer with the #{framework} wrappers" do
      run_generator ['--framework', framework]
    assert_file 'config/initializers/simple_form.rb',
      /config\.default_wrapper = :default/, /config\.boolean_style = :nested/
    assert_file "config/initializers/simple_form_#{framework}.rb", /config\.wrappers :#{framework}/,
      /config\.default_wrapper = :#{framework}/
    end
  end

  %W(erb haml slim).each do |engine|
    test "generates the scaffold template when using #{engine}" do
      run_generator ['-e', engine]
      assert_file "lib/templates/#{engine}/scaffold/_form.html.#{engine}"
    end
  end
end
