module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute, :column,
                :input_type, :options

    # Basic input helper, combines all simple form component stack to generate
    # a full component based on options the user define and some guesses through
    # database column information. By default a call to input will generate
    # label + input + hint (when defined) + errors (when exists), and all can be
    # configured inside a wrapper html.
    # Examples:
    #   # Imagine @user has error "can't be blank" on name
    #   simple_form_for @user do |f|
    #     f.input :name, :hint => 'My hint'
    #   end
    #
    #   This is the output html (only the input portion, not the form):
    #     <label class="string required" for="user_name"><abbr title="required">*</abbr> Super User Name!</label>
    #     <input class="string required" id="user_name" maxlength="100" name="user[name]" size="100" type="text" value="New in Simple Form!" />
    #     <span class="hint">My hint</span>
    #     <span class="error">can't be blank</span>
    #
    # Each database type will render a default input, based on some mappings and
    # heuristic to determine which is the best option.
    # You have some options for the input to enable/disable some functions:
    #
    #   :as    => allows you to define the input type you want, for instance you
    #             can use it to generate a text field for a date column.
    #   :label => when false, no label will be generated. When a string is given,
    #             it will be used as the label text. Otherwise will lookup i18n.
    #   :hint  => when false, no hint will be generated, even if you have some
    #             declared using i18n. The string passed will be used as the hint.
    #   :required   => defines whether this attribute is required or not. True
    #                  by default.
    #   :collection => use to determine a collection that will be used together
    #                  with collection selects or radios.
    #   :label_html => html options for the label tag
    #   :input_html => html options for the input tag
    #   :hint_html  => html options for the hint tag
    #   :error_html => html optinos for the error tag
    #   :wrapper_html => html options for the wrapper html, when it is configured.
    #
    def input(*args)
      define_simple_form_attributes(*args)

      component = SimpleForm.terminator
      SimpleForm.components.reverse.each do |klass|
        next if @options[klass.basename] == false
        component = klass.new(self, component)
      end

      component.call
    end

    # Creates an error tag based on the given attribute, only when the attribute
    # contains errors. Allows you to pass in all error options, such as
    # :error_html.
    def error(*args)
      define_simple_form_attributes(*args)
      SimpleForm::Components::Error.new(self, SimpleForm.terminator).call
    end

    # Creates a hint tag for the given attribute. Requires the :hint option to
    # be given, or a hint configured through i18n. Allows using default hint
    # options such as :hint_html.
    def hint(*args)
      define_simple_form_attributes(*args)
      SimpleForm::Components::Hint.new(self, SimpleForm.terminator).call
    end

    # Creates a default label tag for the given attribute. You can give a label
    # through the :label option, or using i18n, or the attribute name will be
    # used. Allows you to pass other label options such as :label_html and
    # required.
    # When you use it as a default Rails label, ie passing the second parameter
    # as string, the label will just delegate to default Rails label.
    # TODO: as we are overriding default label method, we need a way to call the
    # default label from rails, or use content tags inside our own helpers.
    # Check whether we should remove label call, change method name or use content_tag
    def label(*args)
      # use default label if we pass the string as usually
      return super if args.second.is_a?(String)

      define_simple_form_attributes(*args)
      SimpleForm::Components::Label.new(self, SimpleForm.terminator).call
    end

  private

    # Setup default simple form attributes.
    def define_simple_form_attributes(*args)
      options = args.extract_options!
      attribute = args.shift

      @attribute, @options = attribute, options
      @column = find_attribute_column
      @input_type = default_input_type
    end

    # Attempt to guess the better input type given the defined options. By
    # default alwayls fallback to the user :as option, or to a :select when a
    # collection is given.
    def default_input_type
      return @options[:as].to_sym if @options[:as]
      return :select              if @options[:collection]

      input_type = column.try(:type)

      case input_type
        when :timestamp
          :datetime
        when :string, nil
          @attribute.to_s =~ /password/ ? :password : :string
        else
          input_type
      end
    end

    # Finds the database column for the given attribute
    def find_attribute_column
      @object.column_for_attribute(@attribute) if @object.respond_to?(:column_for_attribute)
    end

  end
end
