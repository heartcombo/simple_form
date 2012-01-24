module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object

    extend MapType
    include SimpleForm::Inputs

    map_type :text,                                :to => SimpleForm::Inputs::TextInput
    map_type :file,                                :to => SimpleForm::Inputs::FileInput
    map_type :string, :email, :search, :tel, :url, :to => SimpleForm::Inputs::StringInput
    map_type :password,                            :to => SimpleForm::Inputs::PasswordInput
    map_type :integer, :decimal, :float,           :to => SimpleForm::Inputs::NumericInput
    map_type :range,                               :to => SimpleForm::Inputs::RangeInput
    map_type :select, :radio, :check_boxes,        :to => SimpleForm::Inputs::CollectionInput
    map_type :date, :time, :datetime,              :to => SimpleForm::Inputs::DateTimeInput
    map_type :country, :time_zone,                 :to => SimpleForm::Inputs::PriorityInput
    map_type :boolean,                             :to => SimpleForm::Inputs::BooleanInput

    def self.discovery_cache
      @discovery_cache ||= {}
    end

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
    def input(attribute_name, options={}, &block)
      column     = find_attribute_column(attribute_name)
      input_type = default_input_type(attribute_name, column, options)

      if block_given?
        SimpleForm::Inputs::BlockInput.new(self, attribute_name, column, input_type, options, &block).render
      else
        find_mapping(input_type).new(self, attribute_name, column, input_type, options).render
      end
    end
    alias :attribute :input

    # Creates a input tag for the given attribute. All the given options
    # are sent as :input_html.
    #
    # == Examples
    #
    #   simple_form_for @user do |f|
    #     f.input_field :name
    #   end
    #
    # This is the output html (only the input portion, not the form):
    #
    #     <input class="string required" id="user_name" maxlength="100"
    #        name="user[name]" size="100" type="text" value="Carlos" />
    #
    def input_field(attribute_name, options={})
      column     = find_attribute_column(attribute_name)
      input_type = default_input_type(attribute_name, column, options)

      options[:input_html] = options.except(:as, :collection, :label_method, :value_method)

      find_mapping(input_type).new(self, attribute_name, column, input_type, options).input
    end

    # Helper for dealing with association selects/radios, generating the
    # collection automatically. It's just a wrapper to input, so all options
    # supported in input are also supported by association. Some extra options
    # can also be given:
    #
    # == Examples
    #
    #   simple_form_for @user do |f|
    #     f.association :company          # Company.all
    #   end
    #
    #   f.association :company, :collection => Company.all(:order => 'name')
    #   # Same as using :order option, but overriding collection
    #
    # == Block
    #
    # When a block is given, association simple behaves as a proxy to
    # simple_fields_for:
    #
    #   f.association :company do |c|
    #     c.input :name
    #     c.input :type
    #   end
    #
    # From the options above, only :collection can also be supplied.
    #
    def association(association, options={}, &block)
      return simple_fields_for(*[association,
        options.delete(:collection), options].compact, &block) if block_given?

      raise ArgumentError, "Association cannot be used in forms not associated with an object" unless @object

      reflection = find_association_reflection(association)
      raise "Association #{association.inspect} not found" unless reflection

      options[:as] ||= :select
      options[:collection] ||= reflection.klass.all(reflection.options.slice(:conditions, :order))

      attribute = case reflection.macro
        when :belongs_to
          reflection.options[:foreign_key] || :"#{reflection.name}_id"
        when :has_one
          raise ":has_one associations are not supported by f.association"
        else
          if options[:as] == :select
            html_options = options[:input_html] ||= {}
            html_options[:size]   ||= 5
            html_options[:multiple] = true unless html_options.key?(:multiple)
          end

          # Force the association to be preloaded for performance.
          if options[:preload] != false && object.respond_to?(association)
            target = object.send(association)
            target.to_a if target.respond_to?(:to_a)
          end

          :"#{reflection.name.to_s.singularize}_ids"
      end

      input(attribute, options.merge(:reflection => reflection))
    end

    # Creates a button:
    #
    #   form_for @user do |f|
    #     f.button :submit
    #   end
    #
    # It just acts as a proxy to method name given.
    #
    def button(type, *args, &block)
      options = args.extract_options!
      options[:class] = "button #{options[:class]}".strip
      args << options
      if respond_to?("#{type}_button")
        send("#{type}_button", *args, &block)
      else
        send(type, *args, &block)
      end
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
      options[:error_html] = options.except(:error_tag, :error_prefix, :error_method)
      column      = find_attribute_column(attribute_name)
      input_type  = default_input_type(attribute_name, column, options)
      SimpleForm::Inputs::Base.new(self, attribute_name, column, input_type, options).error
    end

    # Return the error but also considering its name. This is used
    # when errors for a hidden field need to be shown.
    #
    # == Examples
    #
    #    f.full_error :token #=> <span class="error">Token is invalid</span>
    #
    def full_error(attribute_name, options={})
      options[:error_prefix] ||= if object.class.respond_to?(:human_attribute_name)
        object.class.human_attribute_name(attribute_name.to_s)
      else
        attribute_name.to_s.humanize
      end

      error(attribute_name, options)
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
      options[:hint_html] = options.except(:hint_tag)
      if attribute_name.is_a?(String)
        options[:hint] = attribute_name
        attribute_name, column, input_type = nil, nil, nil
      else
        column      = find_attribute_column(attribute_name)
        input_type  = default_input_type(attribute_name, column, options)
      end
      SimpleForm::Inputs::Base.new(self, attribute_name, column, input_type, options).hint
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
      return super if args.first.is_a?(String) || block_given?
      options = args.extract_options!
      options[:label_html] = options.dup
      options[:label]      = options.delete(:label)
      options[:required]   = options.delete(:required)
      column      = find_attribute_column(attribute_name)
      input_type  = default_input_type(attribute_name, column, options)
      SimpleForm::Inputs::Base.new(self, attribute_name, column, input_type, options).label
    end

    # Creates an error notification message that only appears when the form object
    # has some error. You can give a specific message with the :message option,
    # otherwise it will look for a message using I18n. All other options given are
    # passed straight as html options to the html tag.
    #
    # == Examples
    #
    #    f.error_notification
    #    f.error_notification :message => 'Something went wrong'
    #    f.error_notification :id => 'user_error_message', :class => 'form_error'
    #
    def error_notification(options={})
      SimpleForm::ErrorNotification.new(self, options).render
    end

  private

    # Attempt to guess the better input type given the defined options. By
    # default alwayls fallback to the user :as option, or to a :select when a
    # collection is given.
    def default_input_type(attribute_name, column, options) #:nodoc:
      return options[:as].to_sym if options[:as]
      return :select             if options[:collection]
      custom_type = find_custom_type(attribute_name.to_s) and return custom_type

      input_type = column.try(:type)
      case input_type
      when :timestamp
        :datetime
      when :string, nil
        case attribute_name.to_s
        when /password/  then :password
        when /time_zone/ then :time_zone
        when /country/   then :country
        when /email/     then :email
        when /phone/     then :tel
        when /url/       then :url
        else
          file_method?(attribute_name) ? :file : (input_type || :string)
        end
      else
        input_type
      end
    end

    def find_custom_type(attribute_name) #:nodoc:
      SimpleForm.input_mappings.find { |match, type|
        attribute_name =~ match
      }.try(:last) if SimpleForm.input_mappings
    end

    def file_method?(attribute_name) #:nodoc:
      file = @object.send(attribute_name) if @object.respond_to?(attribute_name)
      file && SimpleForm.file_methods.any? { |m| file.respond_to?(m) }
    end

    def find_attribute_column(attribute_name) #:nodoc:
      if @object.respond_to?(:column_for_attribute)
        @object.column_for_attribute(attribute_name)
      end
    end

    def find_association_reflection(association) #:nodoc:
      if @object.class.respond_to?(:reflect_on_association)
        @object.class.reflect_on_association(association)
      end
    end

    # Attempts to find a mapping. It follows the following rules:
    #
    # 1) It tries to find a registered mapping, if succeeds:
    #    a) Try to find an alternative with the same name in the Object scope
    #    b) Or use the found mapping
    # 2) If not, fallbacks to #{input_type}Input
    # 3) If not, fallbacks to SimpleForm::Inputs::#{input_type}Input
    def find_mapping(input_type) #:nodoc:
      discovery_cache[input_type] ||=
        if mapping = self.class.mappings[input_type]
          mapping_override(mapping) || mapping
        else
          camelized = "#{input_type.to_s.camelize}Input"
          attempt_mapping(camelized, Object) || attempt_mapping(camelized, self.class) ||
            raise("No input found for #{input_type}")
        end
    end

    # If cache_discovery is enabled, use the class level cache that persists
    # between requests, otherwise use the instance one.
    def discovery_cache #:nodoc:
      if SimpleForm.cache_discovery
        self.class.discovery_cache
      else
        @discovery_cache ||= {}
      end
    end

    def mapping_override(klass) #:nodoc:
      name = klass.name
      if name =~ /^SimpleForm::Inputs/
        attempt_mapping name.split("::").last, Object
      end
    end

    def attempt_mapping(mapping, at) #:nodoc:
      return if SimpleForm.inputs_discovery == false && at == Object

      begin
        at.const_get(mapping)
      rescue NameError => e
        e.message =~ /#{mapping}$/ ? nil : raise
      end
    end
  end
end
