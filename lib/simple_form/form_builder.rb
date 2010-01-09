module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute_name, :column,
                :reflection, :input_type, :options

    TERMINATOR = lambda { "" }

    # Basic input helper, combines all components in the stack to generate
    # input html based on options the user define and some guesses through
    # database column information. By default a call to input will generate
    # label + input + hint (when defined) + errors (when exists), and all can
    # be configured inside a wrapper html.
    #
    # == Examples
    #
    #   # Imagine @user has error "can't be blank" on name
    #   simple_form_for @user do |f|
    #     f.input :name, :hint => 'My hint'
    #   end
    #
    # This is the output html (only the input portion, not the form):
    #
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
    # prompt and/or include blank. Such options are given in plainly:
    #
    #    f.input :created_at, :include_blank => true
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
    # == Priority
    #
    # Some inputs, as :time_zone and :country accepts a :priority option. If none is
    # given SimpleForm.time_zone_priority and SimpleForm.country_priority are used respectivelly.
    #
    module Labels
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods #:nodoc:
        include I18nCache

        def translate_required_html
          i18n_cache :translate_required_html do
            I18n.t(:"simple_form.required.html", :default =>
              %[<abbr title="#{translate_required_text}">#{translate_required_mark}</abbr>]
            )
          end
        end

        def translate_required_text
          I18n.t(:"simple_form.required.text", :default => 'required')
        end

        def translate_required_mark
          I18n.t(:"simple_form.required.mark", :default => '*')
        end
      end

      def label
        @builder.label(label_target, label_text, label_html_options)
      end

      def label_text
        SimpleForm.label_text.call(raw_label_text, required_label_text)
      end
      
      # TODO Fix me
      def label_target
        case input_type
          when :date, :datetime
            "#{attribute_name}_1i"
          when :time
            "#{attribute_name}_4i"
          else
            attribute_name
        end
      end
      
      # TODO Why default_css_options only in labels?
      def label_html_options
        label_options = html_options_for(:label, input_type, required_class)
        label_options[:for] = options[:input_html][:id] if options.key?(:input_html)
        label_options
      end
    
    protected
    
      def raw_label_text #:nodoc:
        options[:label] || label_translation
      end

      # Default required text when attribute is required.
      def required_label_text #:nodoc:
        attribute_required? ? self.class.translate_required_html.dup : ''
      end

      # First check human attribute name and then labels.
      # TODO Remove me in Rails > 2.3.5
      def label_translation #:nodoc:
        default = if object.class.respond_to?(:human_attribute_name)
          object.class.human_attribute_name(reflection_or_attribute_name.to_s)
        else
          attribute_name.to_s.humanize
        end

        translate(:labels, default)
      end
    end

    module Hints
      def hint
        template.content_tag(hint_tag, hint_text, hint_html_options) unless hint_text.blank?
      end

      def hint_tag
        options[:hint_tag] || SimpleForm.hint_tag
      end

      def hint_text
        @hint_text ||= options[:hint] || translate(:hints)
      end

      def hint_html_options
        html_options_for(:hint, :hint)
      end
    end

    module Errors
      def error
        template.content_tag(error_tag, error_text, error_html_options) if object && errors.present?
      end

      def error_tag
        options[:error_tag] || SimpleForm.error_tag
      end

      def error_text
        errors.to_sentence
      end

      def error_html_options
        html_options_for(:error, :error)
      end

    protected

      def errors
        @errors ||= (errors_on_attribute + errors_on_association).compact
      end

      def errors_on_attribute
        Array(object.errors[attribute_name])
      end

      def errors_on_association
        reflection ? Array(object.errors[reflection.name]) : []
      end
    end

    class Input
      include Errors
      include Hints
      include Labels

      delegate :template, :object, :object_name, :attribute_name, :column,
               :reflection, :input_type, :options, :to => :@builder

      def initialize(builder)
        @builder = builder
      end

      def input
        SimpleForm::Components::Input.new(@builder, TERMINATOR).__content
      end

      def render
        pieces = SimpleForm.components.select { |n| n unless @builder.options[n] == false }
        terminator = lambda { pieces.map!{ |p| send(p).to_s }.join }
        SimpleForm::Components::Wrapper.new(@builder, terminator).call
      end

    protected
    
      # When action is create or update, we still should use new and edit
      ACTIONS = {
        :create => :new,
        :update => :edit
      }

      def attribute_required?
        options[:required] != false
      end

      def required_class
        attribute_required? ? :required : :optional
      end

      # Find reflection name when available, otherwise use attribute
      def reflection_or_attribute_name
        reflection ? reflection.name : attribute_name
      end

      # Retrieve options for the given namespace from the options hash
      def html_options_for(namespace, *extra)
        html_options = options[:"#{namespace}_html"] || {}
        html_options[:class] = (extra << html_options[:class]).join(' ').strip if extra.present?
        html_options
      end

      # Lookup translations for the given namespace using I18n, based on object name,
      # actual action and attribute name. Lookup priority as follows:
      #
      #   simple_form.{namespace}.{model}.{action}.{attribute}
      #   simple_form.{namespace}.{model}.{attribute}
      #   simple_form.{namespace}.{attribute}
      #
      #  Namespace is used for :labels and :hints.
      #
      #  Model is the actual object name, for a @user object you'll have :user.
      #  Action is the action being rendered, usually :new or :edit.
      #  And attribute is the attribute itself, :name for example.
      #
      #  Example:
      #
      #    simple_form:
      #      labels:
      #        user:
      #          new:
      #            email: 'E-mail para efetuar o sign in.'
      #          edit:
      #            email: 'E-mail.'
      #
      #  Take a look at our locale example file.
      def translate(namespace, default='')
        lookups = []
        lookups << :"#{object_name}.#{lookup_action}.#{reflection_or_attribute_name}"
        lookups << :"#{object_name}.#{reflection_or_attribute_name}"
        lookups << :"#{reflection_or_attribute_name}"
        lookups << default
        I18n.t(lookups.shift, :scope => :"simple_form.#{namespace}", :default => lookups)
      end

      # The action to be used in lookup.
      def lookup_action
        action = template.controller.action_name.to_sym
        ACTIONS[action] || action
      end
    end

    def input(attribute_name, options={})
      define_simple_form_attributes(attribute_name, options)
      Input.new(self).render
    end
    alias :attribute :input

    # Helper for dealing with association selects/radios, generating the
    # collection automatically. It's just a wrapper to input, so all options
    # supported in input are also supported by association. Some extra options
    # can also be given:
    #
    # == Options
    #
    # * :conditions - Given as conditions when retrieving the collection
    #
    # * :include - Given as include when retrieving the collection
    #
    # * :joins - Given as joins when retrieving the collection
    #
    # * :order - Given as order when retrieving the collection
    #
    # * :scope - Given as scopes when retrieving the collection
    #
    # == Examples
    #
    #   simple_form_for @user do |f|
    #     f.association :company          # Company.all
    #   end
    #
    #   f.association :company, :order => 'name'
    #   # Company.all(:order => 'name')
    #
    #   f.association :company, :conditions => { :active => true }
    #   # Company.all(:conditions => { :active => true })
    #
    #   f.association :company, :collection => Company.all(:order => 'name')
    #   # Same as using :order option, but overriding collection
    #
    #   f.association :company, :scope => [ :public, :not_broken ]
    #   # Same as doing Company.public.not_broken.all
    #
    def association(association, options={})
      raise ArgumentError, "Association cannot be used in forms not associated with an object" unless @object

      options[:as] ||= :select
      @reflection = find_association_reflection(association)
      raise "Association #{association.inspect} not found" unless @reflection

      case @reflection.macro
        when :belongs_to
          attribute = @reflection.options[:foreign_key] || :"#{@reflection.name}_id"
        when :has_one
          raise ":has_one association are not supported by f.association"
        else
          attribute = :"#{@reflection.name.to_s.singularize}_ids"

          if options[:as] == :select
            html_options = options[:input_html] ||= {}
            html_options[:size]   ||= 5
            html_options[:multiple] = true unless html_options.key?(:multiple)
          end
      end

      options[:collection] ||= begin
        find_options = options.slice(:conditions, :order, :include, :joins)
        klass = Array(options[:scope]).inject(@reflection.klass) do |klass, scope|
          klass.send(scope)
        end
        klass.all(find_options)
      end

      returning(input(attribute, options)) { @reflection = nil }
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
      key     = @object ? (@object.new_record? ? :create : :update) : :submit

      value ||= begin
        model = if @object.class.respond_to?(:human_name)
          @object.class.human_name
        else
          @object_name.to_s.humanize
        end

        I18n.t(:"simple_form.buttons.#{key}", :model => model, :default => "#{key.to_s.humanize} #{model}")
      end

      options[:class] = "#{key} #{options[:class]}".strip
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
    def error(attribute_name, options={})
      define_simple_form_attributes(attribute_name, :error_html => options)
      SimpleForm::Components::Error.new(self, TERMINATOR).call
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
    def hint(attribute_name, options={})
      attribute_name, options[:hint] = nil, attribute_name if attribute_name.is_a?(String)
      define_simple_form_attributes(attribute_name, :hint => options.delete(:hint), :hint_html => options)
      SimpleForm::Components::Hint.new(self, TERMINATOR).call
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
    def label(attribute_name, *args)
      return super if args.first.is_a?(String)
      options = args.extract_options!
      define_simple_form_attributes(attribute_name, :label => options.delete(:label),
        :label_html => options, :required => options.delete(:required))
      SimpleForm::Components::Label.new(self, TERMINATOR).call
    end

  private

    # Setup default simple form attributes.
    def define_simple_form_attributes(attribute_name, options) #:nodoc:
      @options = options

      if @attribute_name = attribute_name
        @column     = find_attribute_column
        @input_type = default_input_type
      end
    end

    # Attempt to guess the better input type given the defined options. By
    # default alwayls fallback to the user :as option, or to a :select when a
    # collection is given.
    def default_input_type #:nodoc:
      return @options[:as].to_sym if @options[:as]
      return :select              if @options[:collection]

      input_type = @column.try(:type)

      case input_type
        when :timestamp
          :datetime
        when :string, nil
          match = case @attribute_name.to_s
            when /password/  then :password
            when /time_zone/ then :time_zone
            when /country/   then :country
          end

          match || input_type || file_method? || :string
        else
          input_type
      end
    end

    # Checks if attribute is a file_method.
    def file_method? #:nodoc:
      file = @object.send(@attribute_name) if @object.respond_to?(@attribute_name)
      :file if file && SimpleForm.file_methods.any? { |m| file.respond_to?(m) }
    end

    # Finds the database column for the given attribute
    def find_attribute_column #:nodoc:
      @object.column_for_attribute(@attribute_name) if @object.respond_to?(:column_for_attribute)
    end

    # Find reflection related to association
    def find_association_reflection(association) #:nodoc:
      @object.class.reflect_on_association(association) if @object.class.respond_to?(:reflect_on_association)
    end

  end
end
