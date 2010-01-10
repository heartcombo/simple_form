module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute_name, :column,
                :reflection, :input_type, :options

    extend MapType
    include SimpleForm::Inputs

    map_type :boolean, :password, :text, :file,   :to => SimpleForm::Inputs::MappingInput
    map_type :string, :integer, :decimal, :float, :to => SimpleForm::Inputs::TextFieldInput
    map_type :select, :radio, :check_boxes,       :to => SimpleForm::Inputs::CollectionInput
    map_type :date, :time, :datetime,             :to => SimpleForm::Inputs::DateTimeInput
    map_type :country, :time_zone,                :to => SimpleForm::Inputs::PriorityInput

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
      define_simple_form_attributes(attribute_name, options)

      if block_given?
        SimpleForm::Inputs::BlockInput.new(self, block).render
      else
        klass = self.class.mappings[input_type] ||
          self.class.const_get(:"#{input_type.to_s.camelize}Input")
        klass.new(self).render
      end
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
        finders = options.slice(:conditions, :order, :include, :joins)
        finders[:conditions] = @reflection.klass.merge_conditions(finders[:conditions],
          @reflection.options[:conditions])
        klass = Array(options[:scope]).inject(@reflection.klass) do |klass, scope|
          klass.send(scope)
        end
        klass.all(finders)
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
      SimpleForm::Inputs::Base.new(self).error
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
      SimpleForm::Inputs::Base.new(self).hint
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
      SimpleForm::Inputs::Base.new(self).label
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
