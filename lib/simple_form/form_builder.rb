module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute, :column, :input_type, :options

    # Basic input helper, combines all components in the stack to generate input
    # html  based on options the user define and some guesses through
    # database column information. By default a call to input will generate
    # label + input + hint (when defined) + errors (when exists), and all can be
    # configured inside a wrapper html.
    #
    # Examples:
    #
    #   # Imagine @user has error "can't be blank" on name
    #   simple_form_for @user do |f|
    #     f.input :name, :hint => 'My hint'
    #   end
    #
    #   This is the output html (only the input portion, not the form):
    #     <label class="string required" for="user_name">
    #       <abbr title="required">*</abbr> Super User Name!
    #     </label>
    #     <input class="string required" id="user_name" maxlength="100"
    #        name="user[name]" size="100" type="text" value="Carlos" />
    #     <span class="hint">My hint</span>
    #     <span class="error">can't be blank</span>
    #
    # Each database type will render a default input, based on some mappings and
    # heuristic to determine which is the best option.
    #
    # You have some options for the input to enable/disable some functions:
    #
    #   :as => allows you to define the input type you want, for instance you
    #          can use it to generate a text field for a date column.
    #
    #   :required => defines whether this attribute is required or not. True
    #               by default.
    #
    # The fact SimpleForm is built in components allow the interface to be unified.
    # So, for instance, if you need to disable :hint for a given input, you can pass
    # :hint => false. The same works for :error, :label and :wrapper.
    #
    # Besides the html for any component can be changed. So, if you want to change
    # the label html you just need to give a hash to :label_html. To configure the
    # input html, supply :input_html instead and so on.
    #
    # == Options
    #
    # Some inputs, as datetime, time and select allow you to give extra options, like
    # prompt and/or include blank. Such options are given in the :options key.
    #
    #    f.input :created_at, :options => { :include_blank => true }
    #
    # == Collection
    #
    # When playing with collections (:radio and :select inputs), you have three extra
    # options:
    #
    #   :collection => use to determine the collection to generate the radio or select
    #
    #   :label_method => the method to apply on the array collection to get the label
    #
    #   :value_method => the method to apply on the array collection to get the value
    #
    def input(attribute, options={})
      define_simple_form_attributes(attribute, options)

      component = SimpleForm.terminator
      SimpleForm.components.reverse.each do |klass|
        next if @options[klass.basename] == false
        component = klass.new(self, component)
      end
      component.call
    end

    # Creates a button:
    #
    #   form_for @user do |f|
    #     f.button :submit
    #   end
    #
    # If the record is a new_record?, it will create a button with label "Create User",
    # otherwise it will create with label "Update User". You can overwrite the label
    # giving a second parameter or giving :label.
    #
    #   f.button :submit, "Create a new user"
    #   f.button :submit, :label => "Create a new user"
    #
    # button is actually just a wrapper that adds a default text, that said, f.button
    # above is just calling:
    #
    #   submit_tag "Create a new user"
    #
    # All options given to button are given straight to submit_tag. That said, you can
    # use :confirm normally:
    #
    #   f.button :submit, :confirm => "Are you sure?"
    #
    # And if you want to use image_submit_tag, just give it as an option:
    #
    #   f.button :image_submit, "/images/foo/bar.png"
    #
    # This comes with a bonus that any method added to your ApplicationController can
    # be used by SimpleForm, as long as it ends with _tag. So is quite easy to customize
    # your buttons.
    #
    def button(type, *args)
      options = args.extract_options!
      value   = args.first || options.delete(:label)

      value ||= begin
        if @object
          key   = @object.new_record? ? :create : :update
          model = @object.class.human_name if @object.class.respond_to?(:human_name)
        end
        key   ||= :submit
        model ||= @object_name.to_s.humanize

        I18n.t(:"simple_form.#{key}", :model => model, :default => "#{key.to_s.humanize} #{model}")
      end

      @template.send(:"#{type}_tag", value, options)
    end

    # Creates an error tag based on the given attribute, only when the attribute
    # contains errors. All the given options are sent as :error_html.
    #
    # == Examples
    #
    #    f.error :name
    #    f.error :name, :id => "cool_error"
    #
    def error(attribute, options={})
      define_simple_form_attributes(attribute, :error_html => options)
      SimpleForm::Components::Error.new(self, SimpleForm.terminator).call
    end

    # Creates a hint tag for the given attribute. Accepts a symbol indicating
    # an attribute for I18n lookup or a string. All the given options are sent
    # as :hint_html.
    #
    # == Examples
    #
    #    f.hint :name # Do I18n lookup
    #    f.hint :name, :id => "cool_hint"
    #    f.hint "Don't forget to accept this"
    #
    def hint(attribute, options={})
      attribute, options[:hint] = nil, attribute if attribute.is_a?(String)
      define_simple_form_attributes(attribute, :hint => options.delete(:hint), :hint_html => options)
      SimpleForm::Components::Hint.new(self, SimpleForm.terminator).call
    end

    # Creates a default label tag for the given attribute. You can give a label
    # through the :label option or using i18n. All the given options are sent
    # as :label_html.
    #
    # == Examples
    #
    #    f.label :name                     # Do I18n lookup
    #    f.label :name, "Name"             # Same behavior as Rails, do not add required tag
    #    f.label :name, :label => "Name"   # Same as above, but adds required tag
    #
    #    f.label :name, :required => false
    #    f.label :name, :id => "cool_label"
    #
    def label(attribute, *args)
      return super if args.first.is_a?(String)
      options = args.extract_options!
      define_simple_form_attributes(attribute, :label => options.delete(:label),
        :label_html => options, :required => options.delete(:required))
      SimpleForm::Components::Label.new(self, SimpleForm.terminator).call
    end

  private

    # Setup default simple form attributes.
    def define_simple_form_attributes(attribute, options)
      @options = options

      if @attribute = attribute
        @column     = find_attribute_column
        @input_type = default_input_type
      end
    end

    # Attempt to guess the better input type given the defined options. By
    # default alwayls fallback to the user :as option, or to a :select when a
    # collection is given.
    def default_input_type
      return @options[:as].to_sym if @options[:as]
      return :select              if @options[:collection]

      input_type = @column.try(:type)

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
