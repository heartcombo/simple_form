# encoding: UTF-8
require 'test_helper'

class InputTest < ActionView::TestCase

  setup do
    SimpleForm::Inputs::CollectionInput.reset_i18n_cache :boolean_collection
  end

  def with_input_for(object, attribute_name, type, options={})
    with_concat_form_for(object) do |f|
      f.input(attribute_name, options.merge(:as => type))
    end
  end

  # ALL
  test 'input should generate css class based on default input type' do
    with_input_for @user, :name, :string
    assert_select 'input.string'
    with_input_for @user, :description, :text
    assert_select 'textarea.text'
    with_input_for @user, :age, :integer
    assert_select 'input.integer'
    with_input_for @user, :born_at, :date
    assert_select 'select.date'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime'
  end

  test 'input should generate disabled elements based on the disabled option' do
    with_input_for @user, :name, :string, :disabled => true
    assert_select 'input.string[disabled]'
    with_input_for @user, :description, :text, :disabled => true
    assert_select 'textarea.text[disabled]'
    with_input_for @user, :age, :integer, :disabled => true
    assert_select 'input.integer[disabled]'
    with_input_for @user, :born_at, :date, :disabled => true
    assert_select 'select.date[disabled]'
    with_input_for @user, :created_at, :datetime, :disabled => true
    assert_select 'select.datetime[disabled]'

    with_input_for @user, :name, :string, :disabled => false
    assert_select 'input.string:not([disabled])'
    with_input_for @user, :description, :text, :disabled => false
    assert_select 'textarea.text:not([disabled])'
    with_input_for @user, :age, :integer, :disabled => false
    assert_select 'input.integer:not([disabled])'
    with_input_for @user, :born_at, :date, :disabled => false
    assert_select 'select.date:not([disabled])'
    with_input_for @user, :created_at, :datetime, :disabled => false
    assert_select 'select.datetime:not([disabled])'

    with_input_for @user, :name, :string
    assert_select 'input.string:not([disabled])'
    with_input_for @user, :description, :text
    assert_select 'textarea.text:not([disabled])'
    with_input_for @user, :age, :integer
    assert_select 'input.integer:not([disabled])'
    with_input_for @user, :born_at, :date
    assert_select 'select.date:not([disabled])'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime:not([disabled])'
  end

  test 'input should generate autofocus attribute based on the autofocus option' do
    with_input_for @user, :name, :string, :autofocus => true
    assert_select 'input.string[autofocus]'
    with_input_for @user, :description, :text, :autofocus => true
    assert_select 'textarea.text[autofocus]'
    with_input_for @user, :age, :integer, :autofocus => true
    assert_select 'input.integer[autofocus]'
    with_input_for @user, :born_at, :date, :autofocus => true
    assert_select 'select.date[autofocus]'
    with_input_for @user, :created_at, :datetime, :autofocus => true
    assert_select 'select.datetime[autofocus]'

    with_input_for @user, :name, :string, :autofocus => false
    assert_select 'input.string:not([autofocus])'
    with_input_for @user, :description, :text, :autofocus => false
    assert_select 'textarea.text:not([autofocus])'
    with_input_for @user, :age, :integer, :autofocus => false
    assert_select 'input.integer:not([autofocus])'
    with_input_for @user, :born_at, :date, :autofocus => false
    assert_select 'select.date:not([autofocus])'
    with_input_for @user, :created_at, :datetime, :autofocus => false
    assert_select 'select.datetime:not([autofocus])'

    with_input_for @user, :name, :string
    assert_select 'input.string:not([autofocus])'
    with_input_for @user, :description, :text
    assert_select 'textarea.text:not([autofocus])'
    with_input_for @user, :age, :integer
    assert_select 'input.integer:not([autofocus])'
    with_input_for @user, :born_at, :date
    assert_select 'select.date:not([autofocus])'
    with_input_for @user, :created_at, :datetime
    assert_select 'select.datetime:not([autofocus])'
  end

  test "when not using HTML5, it does not generate autofocus attribute" do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :name, :string, :autofocus => true
      assert_no_select 'input.string[autofocus]'
    end
  end

  test 'components option is deprecated' do
    assert_deprecated(/The option :components of f\.input is deprecated/) do
      with_input_for @user, :name, :string, :components => [:input]
    end
  end

  test 'input should render components according to an optional :components option' do
    ActiveSupport::Deprecation.silence do
      with_input_for @user, :name, :string, :components => [:input, :label]
      assert_select 'input + label'

      with_input_for @user, :age, :integer, :components => [:input, :label]
      assert_select 'input + label'

      with_input_for @user, :active, :boolean, :components => [:label, :input]
      assert_select 'label + input'

      with_input_for @user, :description, :text, :components => [:input, :label]
      assert_select 'textarea + label'

      with_input_for @user, :password, :password, :components => [:input, :label]
      assert_select 'input + label'

      with_input_for @user, :name, :file, :components => [:input, :label]
      assert_select 'input + label'

      with_input_for @user, :country, :country, :components => [:input, :label]
      assert_select 'select + label'

      with_input_for @user, :time_zone, :time_zone, :components => [:input, :label]
      assert_select 'select + label'
    end
  end

  # StringInput
  test 'input should map text field to string attribute' do
    with_input_for @user, :name, :string
    assert_select "input#user_name[type=text][name='user[name]'][value=New in Simple Form!]"
  end

  test 'input should generate a password field for password attributes' do
    with_input_for @user, :password, :password
    assert_select "input#user_password.password[type=password][name='user[password]']"
  end

  test 'input should not use size attribute for decimal attributes' do
    with_input_for @user, :credit_limit, :decimal
    assert_no_select 'input.decimal[size]'
  end

  test 'input should get maxlength from column definition for string attributes' do
    with_input_for @user, :name, :string
    assert_select 'input.string[maxlength=100]'
  end

  test 'input should not get maxlength from column without size definition for string attributes' do
    with_input_for @user, :action, :string
    assert_no_select 'input.string[maxlength]'
  end

  test 'input should get size from column definition for string attributes respecting maximum value' do
    with_input_for @user, :name, :string
    assert_select 'input.string[size=50]'
  end

  test 'input should use default text size for password attributes' do
    with_input_for @user, :password, :password
    assert_select 'input.password[type=password][size=50]'
  end

  test 'input should get maxlength from column definition for password attributes' do
    with_input_for @user, :password, :password
    assert_select 'input.password[type=password][maxlength=100]'
  end

  test 'input should infer maxlength column definition from validation when present' do
    with_input_for @validating_user, :name, :string
    assert_select 'input.string[maxlength=25]'
  end

  test 'when not using HTML5, does not show maxlength attribute' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :password, :password
      assert_no_select 'input[type=password][maxlength]'
    end
  end

  test 'when not using HTML5, does not show maxlength attribute with validating lenght attribute' do
    swap SimpleForm, :html5 => false do
      with_input_for @validating_user, :name, :string
      assert_no_select 'input.string[maxlength]'
    end
  end

  test 'input should not generate placeholder by default' do
    with_input_for @user, :name, :string
    assert_no_select 'input[placeholder]'
  end

  test 'input should accept the placeholder option' do
    with_input_for @user, :name, :string, :placeholder => 'Put in some text'
    assert_select 'input.string[placeholder=Put in some text]'
  end

  test 'input should generate a password field for password attributes that accept placeholder' do
    with_input_for @user, :password, :password, :placeholder => 'Password Confirmation'
    assert_select 'input[type=password].password[placeholder=Password Confirmation]#user_password'
  end

  test 'input should use i18n to translate placeholder text' do
    store_translations(:en, :simple_form => { :placeholders => { :user => {
      :name => 'Name goes here'
    } } }) do
      with_input_for @user, :name, :string
      assert_select 'input.string[placeholder=Name goes here]'
    end
  end

  [:email, :url, :search, :tel].each do |type|
    test "input should allow type #{type}" do
      with_input_for @user, :name, type
      assert_select "input.string.#{type}"
      assert_select "input[type=#{type}]"
    end

    test "input should not allow type #{type} if HTML5 compatibility is disabled" do
      swap SimpleForm, :html5 => false do
        with_input_for @user, :name, type
        assert_no_select "input[type=#{type}]"
      end
    end
  end

  test 'input should infer pattern from attributes when pattern is true' do
    with_input_for @other_validating_user, :country, :string, :pattern => true
    assert_select 'input[pattern="\w+"]'
  end

  test 'input should use given pattern from attributes' do
    with_input_for @other_validating_user, :country, :string, :pattern => "\\d+"
    assert_select 'input[pattern="\d+"]'
  end

  test 'input should fail if pattern is true but no pattern exists' do
    assert_raise RuntimeError do
      with_input_for @other_validating_user, :name, :string, :pattern => true
    end
  end

  # NumericInput
  test 'input should generate an integer text field for integer attributes ' do
    with_input_for @user, :age, :integer
    assert_select 'input[type=number].integer#user_age'
  end

  test 'input should generate a float text field for float attributes ' do
    with_input_for @user, :age, :float
    assert_select 'input[type=number].float#user_age'
  end

  test 'input should generate a decimal text field for decimal attributes ' do
    with_input_for @user, :age, :decimal
    assert_select 'input[type=number].decimal#user_age'
  end

  test 'input should not generate min attribute by default' do
    with_input_for @user, :age, :integer
    assert_no_select 'input[min]'
  end

  test 'input should not generate max attribute by default' do
    with_input_for @user, :age, :integer
    assert_no_select 'input[max]'
  end

  test 'input should infer min value from integer attributes with greater than validation' do
    with_input_for @other_validating_user, :age, :float
    assert_no_select 'input[min]'

    with_input_for @other_validating_user, :age, :integer
    assert_select 'input[min=18]'
  end

  test 'input should infer min value from integer attributes with greater than validation using symbol' do
    with_input_for @validating_user, :amount, :float
    assert_no_select 'input[min]'

    with_input_for @validating_user, :amount, :integer
    assert_select 'input[min=11]'
  end

  test 'input should infer min value from integer attributes with greater than or equal to validation using symbol' do
    with_input_for @validating_user, :attempts, :float
    assert_select 'input[min=1]'

    with_input_for @validating_user, :attempts, :integer
    assert_select 'input[min=1]'
  end

  test 'input should infer min value from integer attributes with greater than validation using proc' do
    with_input_for @other_validating_user, :amount, :float
    assert_no_select 'input[min]'

    with_input_for @other_validating_user, :amount, :integer
    assert_select 'input[min=20]'
  end

  test 'input should infer min value from integer attributes with greater than or equal to validation using proc' do
    with_input_for @other_validating_user, :attempts, :float
    assert_select 'input[min=19]'

    with_input_for @other_validating_user, :attempts, :integer
    assert_select 'input[min=19]'
  end

  test 'input should infer max value from attributes with less than validation' do
    with_input_for @other_validating_user, :age, :float
    assert_no_select 'input[max]'

    with_input_for @other_validating_user, :age, :integer
    assert_select 'input[max=99]'
  end

  test 'input should infer max value from attributes with less than validation using symbol' do
    with_input_for @validating_user, :amount, :float
    assert_no_select 'input[max]'

    with_input_for @validating_user, :amount, :integer
    assert_select 'input[max=99]'
  end

  test 'input should infer max value from attributes with less than or equal to validation using symbol' do
    with_input_for @validating_user, :attempts, :float
    assert_select 'input[max=100]'

    with_input_for @validating_user, :attempts, :integer
    assert_select 'input[max=100]'
  end

  test 'input should infer max value from attributes with less than validation using proc' do
    with_input_for @other_validating_user, :amount, :float
    assert_no_select 'input[max]'

    with_input_for @other_validating_user, :amount, :integer
    assert_select 'input[max=118]'
  end

  test 'input should infer max value from attributes with less than or equal to validation using proc' do
    with_input_for @other_validating_user, :attempts, :float
    assert_select 'input[max=119]'

    with_input_for @other_validating_user, :attempts, :integer
    assert_select 'input[max=119]'
  end

  test 'input should have step value of any except for integer attribute' do
    with_input_for @validating_user, :age, :float
    assert_select 'input[step="any"]'

    with_input_for @validating_user, :age, :integer
    assert_select 'input[step=1]'
  end

  test 'numeric input should not generate placeholder by default' do
    with_input_for @user, :age, :integer
    assert_no_select 'input[placeholder]'
  end

  test 'numeric input should accept the placeholder option' do
    with_input_for @user, :age, :integer, :placeholder => 'Put in your age'
    assert_select 'input.integer[placeholder=Put in your age]'
  end

  test 'numeric input should use i18n to translate placeholder text' do
    store_translations(:en, :simple_form => { :placeholders => { :user => {
      :age => 'Age goes here'
    } } }) do
      with_input_for @user, :age, :integer
      assert_select 'input.integer[placeholder=Age goes here]'
    end
  end

  [:integer, :float, :decimal].each do |type|
    test "#{type} input should infer min value from attributes with greater than or equal validation" do
      with_input_for @validating_user, :age, type
      assert_select 'input[min=18]'
    end

    test "#{type} input should infer the max value from attributes with less than or equal to validation" do
      with_input_for @validating_user, :age, type
      assert_select 'input[max=99]'
    end
  end

  # Numeric input but HTML5 disabled
  test 'when not using HTML5 input should not generate field with type number and use text instead' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :age, :integer
      assert_no_select "input[type=number]"
      assert_select "input#user_age[type=text]"
    end
  end

  test 'when not using HTML5 input should not use min or max or step attributes for numeric type' do
    swap SimpleForm, :html5 => false do
      with_input_for @validating_user, :age, :integer
      assert_no_select "input[min]"
      assert_no_select "input[max]"
      assert_no_select "input[step]"
    end
  end

  # RangeInput
  test 'range input generates a input type range, based on numeric input' do
    with_input_for @user, :age, :range
    assert_select "input#user_age.range[type=range]"
  end

  test 'range input does not generate placeholder' do
    with_input_for @user, :age, :range, :placeholder => "Select your age"
    assert_select "input[type=range]"
    assert_no_select "input[placeholder]"
  end

  test 'range input allows givin min and max attributes' do
    with_input_for @user, :age, :range, :input_html => { :min => 10, :max => 50 }
    assert_select "input[type=range][min=10][max=50]"
  end

  test 'range input infers min and max attributes from validations' do
    with_input_for @validating_user, :age, :range
    assert_select "input[type=range][min=18][max=99]"
  end

  test 'range input add default step attribute' do
    with_input_for @validating_user, :age, :range
    assert_select "input[type=range][step=1]"
  end

  test 'range input allows givin a step through input html options' do
    with_input_for @validating_user, :age, :range, :input_html => { :step => 2 }
    assert_select "input[type=range][step=2]"
  end

  test 'range input should not generate min attribute by default' do
    with_input_for @user, :age, :range
    assert_no_select 'input[min]'
  end

  test 'range input should not generate max attribute by default' do
    with_input_for @user, :age, :range
    assert_no_select 'input[max]'
  end

  # RangeInput iwth HTML5 disabled
  test 'when not using HTML5, range input does not generate field with range type, and use text instead' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :age, :range
      assert_no_select "input[type=number]"
      assert_select "input[type=text]"
    end
  end

  test 'when not using HTML5, range input should not use min or max or step attributes' do
    swap SimpleForm, :html5 => false do
      with_input_for @validating_user, :age, :range
      assert_no_select "input[min]"
      assert_no_select "input[max]"
      assert_no_select "input[step]"
    end
  end

  # BooleanInput
  test 'input should generate a checkbox by default for boolean attributes' do
    with_input_for @user, :active, :boolean
    assert_select 'input[type=checkbox].boolean#user_active'
    assert_select 'input.boolean + label.boolean.optional'
  end

  # MappingInput
  test 'input should generate a text area for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text#user_description'
  end

  test 'input should generate a text area for text attributes that accept placeholder' do
    with_input_for @user, :description, :text, :placeholder => 'Put in some text'
    assert_select 'textarea.text[placeholder=Put in some text]'
  end

  test 'input should get maxlength from column definition for text attributes' do
    with_input_for @user, :description, :text
    assert_select 'textarea.text[maxlength=200]'
  end

  test 'input should infer maxlength column definition from validation when present for text attributes' do
    with_input_for @validating_user, :description, :text
    assert_select 'textarea.text[maxlength=50]'
  end

  test 'when not using HTML5, does not show maxlength attribute for text attributes' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :description, :text
      assert_no_select 'textarea.text[maxlength]'
    end
  end

  test 'when not using HTML5, does not show maxlength attribute with validating lenght text attribute' do
    swap SimpleForm, :html5 => false do
      with_input_for @validating_user, :name, :string
      assert_no_select 'input.string[maxlength]'
    end
  end

  test 'input should generate a file field' do
    with_input_for @user, :name, :file
    assert_select 'input#user_name[type=file]'
  end

  test "input should generate a file field that doesn't accept placeholder" do
    with_input_for @user, :name, :file, :placeholder => 'Put in some text'
    assert_no_select 'input[placeholder]'
  end

  # HiddenInput
  test 'input should generate a hidden field' do
    with_input_for @user, :name, :hidden
    assert_no_select 'input[type=text]'
    assert_select 'input#user_name[type=hidden]'
  end

  test 'hint should not be generated for hidden fields' do
    with_input_for @user, :name, :hidden, :hint => 'Use with care...'
    assert_no_select 'span.hint'
  end

  test 'label should not be generated for hidden inputs' do
    with_input_for @user, :name, :hidden
    assert_no_select 'label'
  end

  test 'required/optional options should not be generated for hidden inputs' do
    with_input_for @user, :name, :hidden
    assert_no_select 'input.required'
    assert_no_select 'input[required]'
    assert_no_select 'input.optional'
    assert_select 'input.hidden#user_name'
  end

  # PriorityInput
  test 'input should generate a country select field' do
    with_input_for @user, :country, :country
    assert_select 'select#user_country'
    assert_select 'select option[value=Brazil]', 'Brazil'
    assert_no_select 'select option[value=][disabled=disabled]'
  end

  test 'input should generate a country select with simple form default' do
    swap SimpleForm, :country_priority => [ 'Brazil' ] do
      with_input_for @user, :country, :country
      assert_select 'select option[value=][disabled=disabled]'
    end
  end

  test 'input should generate a time zone select field' do
    with_input_for @user, :time_zone, :time_zone
    assert_select 'select#user_time_zone'
    assert_select 'select option[value=Brasilia]', '(GMT-03:00) Brasilia'
    assert_no_select 'select option[value=][disabled=disabled]'
  end

  test 'input should generate a time zone select field with default' do
    with_input_for @user, :time_zone, :time_zone, :default => 'Brasilia'
    assert_select 'select option[value=Brasilia][selected=selected]'
    assert_no_select 'select option[value=]'
  end

  test 'input should generate a time zone select using options priority' do
    with_input_for @user, :time_zone, :time_zone, :priority => /Brasilia/
    assert_select 'select option[value=][disabled=disabled]'
    assert_no_select 'select option[value=]', /^$/
  end

  test 'priority input should not generate invalid required html attribute' do
    with_input_for @user, :country, :country
    assert_select 'select.required'
    assert_no_select 'select[required]'
  end

  # DateTime input
  test 'input should generate a datetime select by default for datetime attributes' do
    with_input_for @user, :created_at, :datetime
    1.upto(5) do |i|
      assert_select "form select.datetime#user_created_at_#{i}i"
    end
  end

  test 'input should be able to pass options to datetime select' do
    with_input_for @user, :created_at, :datetime,
      :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }

    assert_select 'select.datetime[disabled=disabled]'
    assert_select 'select.datetime option', 'ano'
    assert_select 'select.datetime option', 'mês'
    assert_select 'select.datetime option', 'dia'
  end

  test 'input should generate a date select for date attributes' do
    with_input_for @user, :born_at, :date
    assert_select 'select.date#user_born_at_1i'
    assert_select 'select.date#user_born_at_2i'
    assert_select 'select.date#user_born_at_3i'
    assert_no_select 'select.date#user_born_at_4i'
  end

  test 'input should be able to pass options to date select' do
    with_input_for @user, :born_at, :date, :as => :date,
      :disabled => true, :prompt => { :year => 'ano', :month => 'mês', :day => 'dia' }

    assert_select 'select.date[disabled=disabled]'
    assert_select 'select.date option', 'ano'
    assert_select 'select.date option', 'mês'
    assert_select 'select.date option', 'dia'
  end

  test 'input should be able to pass :default to date select' do
    with_input_for @user, :born_at, :date, :default => Date.today
    assert_select "select.date option[value=#{Date.today.year}][selected=selected]"
  end

  test 'input should generate a time select for time attributes' do
    with_input_for @user, :delivery_time, :time
    assert_select 'input[type=hidden]#user_delivery_time_1i'
    assert_select 'input[type=hidden]#user_delivery_time_2i'
    assert_select 'input[type=hidden]#user_delivery_time_3i'
    assert_select 'select.time#user_delivery_time_4i'
    assert_select 'select.time#user_delivery_time_5i'
  end

  test 'input should be able to pass options to time select' do
    with_input_for @user, :delivery_time, :time, :required => true,
      :disabled => true, :prompt => { :hour => 'hora', :minute => 'minuto' }

    assert_select 'select.time[disabled=disabled]'
    assert_select 'select.time option', 'hora'
    assert_select 'select.time option', 'minuto'
  end

  test 'label should point to first option when date input type' do
    with_input_for :project, :created_at, :date
    assert_select 'label[for=project_created_at_1i]'
  end

  test 'label should point to first option when datetime input type' do
    with_input_for :project, :created_at, :datetime
    assert_select 'label[for=project_created_at_1i]'
  end

  test 'label should point to first option when time input type' do
    with_input_for :project, :created_at, :time
    assert_select 'label[for=project_created_at_4i]'
  end

  test 'date time input should not generate invalid required html attribute' do
    with_input_for @user, :delivery_time, :time, :required => true
    assert_select 'select.required'
    assert_no_select 'select[required]'
  end

  # CollectionInput
  test 'input should generate boolean radio buttons by default for radio types' do
    with_input_for @user, :active, :radio
    assert_select 'input[type=radio][value=true].radio#user_active_true'
    assert_select 'input[type=radio][value=false].radio#user_active_false'
  end

  test 'input as radio should generate internal labels by default' do
    with_input_for @user, :active, :radio
    assert_select 'label[for=user_active_true]', 'Yes'
    assert_select 'label[for=user_active_false]', 'No'
  end

  test 'input as radio should use i18n to translate internal labels' do
    store_translations(:en, :simple_form => { :yes => 'Sim', :no => 'Não' }) do
      with_input_for @user, :active, :radio
      assert_select 'label[for=user_active_true]', 'Sim'
      assert_select 'label[for=user_active_false]', 'Não'
    end
  end

  test 'input should mark the checked value when using boolean and radios' do
    @user.active = false
    with_input_for @user, :active, :radio
    assert_no_select 'input[type=radio][value=true][checked]'
    assert_select 'input[type=radio][value=false][checked]'
  end

  test 'input should generate a boolean select with options by default for select types' do
    with_input_for @user, :active, :select
    assert_select 'select.select#user_active'
    assert_select 'select option[value=true]', 'Yes'
    assert_select 'select option[value=false]', 'No'
  end

  test 'input as select should use i18n to translate select boolean options' do
    store_translations(:en, :simple_form => { :yes => 'Sim', :no => 'Não' }) do
      with_input_for @user, :active, :select
      assert_select 'select option[value=true]', 'Sim'
      assert_select 'select option[value=false]', 'Não'
    end
  end

  test 'input should allow overriding collection for select types' do
    with_input_for @user, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select.select#user_name'
    assert_select 'select option', 'Jose'
    assert_select 'select option', 'Carlos'
  end

  test 'input should mark the selected value by default' do
    @user.name = "Carlos"
    with_input_for @user, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select option[selected=selected]', 'Carlos'
  end

  test 'input should mark the selected value also when using integers' do
    @user.age = 18
    with_input_for @user, :age, :select, :collection => 18..60
    assert_select 'select option[selected=selected]', '18'
  end

  test 'input should mark the selected value when using booleans and select' do
    @user.active = false
    with_input_for @user, :active, :select
    assert_no_select 'select option[selected][value=true]', 'Yes'
    assert_select 'select option[selected][value=false]', 'No'
  end

  test 'input should set the correct value when using a collection that includes floats' do
    with_input_for @user, :age, :select, :collection => [2.0, 2.5, 3.0, 3.5, 4.0, 4.5]
    assert_select 'select option[value="2.0"]'
    assert_select 'select option[value="2.5"]'
  end

  test 'input should set the correct values when using a collection that uses mixed values' do
    with_input_for @user, :age, :select, :collection => ["Hello Kitty", 2, 4.5, :johnny, nil, true, false]
    assert_select 'select option[value="Hello Kitty"]'
    assert_select 'select option[value="2"]'
    assert_select 'select option[value="4.5"]'
    assert_select 'select option[value="johnny"]'
    assert_select 'select option[value=""]'
    assert_select 'select option[value="true"]'
    assert_select 'select option[value="false"]'
  end

  test 'input should include a blank option even if :include_blank is set to false if the collection includes a nil value' do
    with_input_for @user, :age, :select, :collection => [nil], :include_blank => false
    assert_select 'select option[value=""]'
  end

  test 'input should automatically set include blank' do
    with_input_for @user, :age, :select, :collection => 18..30
    assert_select 'select option[value=]', ''
  end

  test 'input should not set include blank if otherwise is told' do
    with_input_for @user, :age, :select, :collection => 18..30, :include_blank => false
    assert_no_select 'select option[value=]', ''
  end

  test 'input should not set include blank if prompt is given' do
    with_input_for @user, :age, :select, :collection => 18..30, :prompt => "Please select foo"
    assert_no_select 'select option[value=]', ''
  end

  test 'input should not set include blank if multiple is given' do
    with_input_for @user, :age, :select, :collection => 18..30, :input_html => { :multiple => true }
    assert_no_select 'select option[value=]', ''
  end

  test 'input should detect label and value on collections' do
    users = [ setup_new_user(:id => 1, :name => "Jose"), setup_new_user(:id => 2, :name => "Carlos") ]
    with_input_for @user, :description, :select, :collection => users
    assert_select 'select option[value=1]', 'Jose'
    assert_select 'select option[value=2]', 'Carlos'
  end

  test 'input should disable the anothers components when the option is a object' do
    with_input_for @user, :description, :select, :collection => ["Jose", "Carlos"], :disabled => true
    assert_no_select 'select option[value=Jose][disabled=disabled]', 'Jose'
    assert_no_select 'select option[value=Carlos][disabled=disabled]', 'Carlos'
    assert_select 'select[disabled=disabled]'
    assert_select 'div.disabled'
  end

  test 'input should not disable the anothers components when the option is a object' do
    with_input_for @user, :description, :select, :collection => ["Jose", "Carlos"], :disabled => 'Jose'
    assert_select 'select option[value=Jose][disabled=disabled]', 'Jose'
    assert_no_select 'select option[value=Carlos][disabled=disabled]', 'Carlos'
    assert_no_select 'select[disabled=disabled]'
    assert_no_select 'div.disabled'
  end

  test 'input should allow disabled options with a lambda for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :disabled => lambda { |x| x == "Carlos" }
    assert_select 'select option[value=Carlos][disabled=disabled]', 'Carlos'
    assert_select 'select option[value=Antonio]', 'Antonio'
    assert_no_select 'select option[value=Antonio][disabled]'
  end

  test 'input should allow disabled and label method with lambdas for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :disabled => lambda { |x| x == "Carlos" }, :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][disabled=disabled]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][disabled]'
  end

  test 'input should allow a non lambda disabled option with lambda label method for collections' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :disabled => "Carlos", :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][disabled=disabled]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][disabled]'
  end

  test 'input should allow selected and label method with lambdas for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :selected => lambda { |x| x == "Carlos" }, :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][selected=selected]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][selected]'
  end

  test 'input should allow a non lambda selected option with lambda label method for collection select' do
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :selected => "Carlos", :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][selected=selected]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][selected]'
  end

  test 'input should not override default selection through attribute value with label method as lambda for collection select' do
    @user.name = "Carlos"
    with_input_for @user, :name, :select, :collection => ["Carlos", "Antonio"],
      :label_method => lambda { |x| x.upcase }
    assert_select 'select option[value=Carlos][selected=selected]', 'CARLOS'
    assert_select 'select option[value=Antonio]', 'ANTONIO'
    assert_no_select 'select option[value=Antonio][selected]'
  end

  test 'input should allow overriding collection for radio types' do
    with_input_for @user, :name, :radio, :collection => ['Jose', 'Carlos']
    assert_select 'input[type=radio][value=Jose]'
    assert_select 'input[type=radio][value=Carlos]'
    assert_select 'label.collection_radio', 'Jose'
    assert_select 'label.collection_radio', 'Carlos'
  end

  test 'input should mark the current radio value by default' do
    @user.name = "Carlos"
    with_input_for @user, :name, :radio, :collection => ['Jose', 'Carlos']
    assert_select 'input[type=radio][value=Carlos][checked=checked]'
  end

  test 'input should allow using a collection with text/value arrays' do
    with_input_for @user, :name, :radio, :collection => [['Jose', 'jose'], ['Carlos', 'carlos']]
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.collection_radio', 'Jose'
    assert_select 'label.collection_radio', 'Carlos'
  end

  test 'input should allow overriding only label method for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => :upcase
    assert_select 'label.collection_radio', 'JOSE'
    assert_select 'label.collection_radio', 'CARLOS'
  end

  test 'input should allow overriding only value method for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :value_method => :upcase
    assert_select 'input[type=radio][value=JOSE]'
    assert_select 'input[type=radio][value=CARLOS]'
  end

  test 'input should allow overriding label and value method for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => :upcase,
                          :value_method => :downcase
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.collection_radio', 'JOSE'
    assert_select 'label.collection_radio', 'CARLOS'
  end

  test 'input should allow overriding label and value method using a lambda for collections' do
    with_input_for @user, :name, :radio,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => lambda { |i| i.upcase },
                          :value_method => lambda { |i| i.downcase }
    assert_select 'input[type=radio][value=jose]'
    assert_select 'input[type=radio][value=carlos]'
    assert_select 'label.collection_radio', 'JOSE'
    assert_select 'label.collection_radio', 'CARLOS'
  end

  test 'input should allow overriding label and value method using a lambda for collection selects' do
    with_input_for @user, :name, :select,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => lambda { |i| i.upcase },
                          :value_method => lambda { |i| i.downcase }
    assert_select 'select option[value=jose]', "JOSE"
    assert_select 'select option[value=carlos]', "CARLOS"
  end

  test 'input should allow overriding only label but not value method using a lambda for collection select' do
    with_input_for @user, :name, :select,
                          :collection => ['Jose' , 'Carlos'],
                          :label_method => lambda { |i| i.upcase }
    assert_select 'select option[value=Jose]', "JOSE"
    assert_select 'select option[value=Carlos]', "CARLOS"
  end

  test 'input should allow overriding only value but not label method using a lambda for collection select' do
    with_input_for @user, :name, :select,
                          :collection => ['Jose' , 'Carlos'],
                          :value_method => lambda { |i| i.downcase }
    assert_select 'select option[value=jose]', "Jose"
    assert_select 'select option[value=carlos]', "Carlos"
  end

  test 'input should allow symbols for collections' do
    with_input_for @user, :name, :select, :collection => [:jose, :carlos]
    assert_select 'select.select#user_name'
    assert_select 'select option[value=jose]', 'jose'
    assert_select 'select option[value=carlos]', 'carlos'
  end

  test 'collection input with radio type should generate required html attribute' do
    with_input_for @user, :name, :radio, :collection => ['Jose' , 'Carlos']
    assert_select 'input[type=radio].required'
    assert_select 'input[type=radio][required]'
  end

  test 'when not using HTML5, collection input with radio type should not generate required html attribute' do
    swap SimpleForm, :html5 => false do
      with_input_for @user, :name, :radio, :collection => ['Jose' , 'Carlos']
      assert_select 'input[type=radio].required'
      assert_no_select 'input[type=radio][required]'
    end
  end

  test 'when not using browser validations, input should not generate required html attribute' do
    swap SimpleForm, :browser_validations => false do
      with_input_for @user, :name, :string
      assert_select 'input[type=text].required'
      assert_no_select 'input[type=text][required]'
    end
  end

  test 'collection input with select type should not generate invalid required html attribute' do
    with_input_for @user, :name, :select, :collection => ['Jose' , 'Carlos']
    assert_select 'select.required'
    assert_no_select 'select[required]'
  end

  # With no object
  test 'input should be generated properly when object is not present' do
    with_input_for :project, :name, :string
    assert_select 'input.string.required#project_name'
  end

  test 'input as radio should be generated properly when object is not present ' do
    with_input_for :project, :name, :radio
    assert_select 'input.radio#project_name_true'
    assert_select 'input.radio#project_name_false'
  end

  test 'input as select with collection should be generated properly when object is not present' do
    with_input_for :project, :name, :select, :collection => ['Jose', 'Carlos']
    assert_select 'select.select#project_name'
  end
end
