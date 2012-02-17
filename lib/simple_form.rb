require 'action_view'
require 'simple_form/action_view_extensions/form_helper'
require 'simple_form/action_view_extensions/builder'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/reverse_merge'

module SimpleForm
  autoload :Components,        'simple_form/components'
  autoload :ErrorNotification, 'simple_form/error_notification'
  autoload :FormBuilder,       'simple_form/form_builder'
  autoload :Helpers,           'simple_form/helpers'
  autoload :I18nCache,         'simple_form/i18n_cache'
  autoload :Inputs,            'simple_form/inputs'
  autoload :MapType,           'simple_form/map_type'
  autoload :Wrappers,          'simple_form/wrappers'

  ## CONFIGURATION OPTIONS

  # Method used to tidy up errors.
  mattr_accessor :error_method
  @@error_method = :first

  # Default tag used for error notification helper.
  mattr_accessor :error_notification_tag
  @@error_notification_tag = :p

  # CSS class to add for error notification helper.
  mattr_accessor :error_notification_class
  @@error_notification_class = :error_notification

  # Series of attemps to detect a default label method for collection.
  mattr_accessor :collection_label_methods
  @@collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection.
  mattr_accessor :collection_value_methods
  @@collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  mattr_accessor :collection_wrapper_tag
  @@collection_wrapper_tag = nil

  # You can define the class to use on all collection wrappers, defaulting to none.
  mattr_accessor :collection_wrapper_class
  @@collection_wrapper_class = nil

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to none. Please note that when using :boolean_style = :nested,
  # SimpleForm will force this option to be a :label.
  mattr_accessor :item_wrapper_tag
  @@item_wrapper_tag = :span

  # You can define the class to use on all item wrappers, defaulting to none.
  mattr_accessor :item_wrapper_class
  @@item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  mattr_accessor :label_text
  @@label_text = lambda { |label, required| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  mattr_accessor :label_class
  @@label_class = nil

  # Define the way to render check boxes / radio buttons with labels.
  #   :inline => input + label (default)
  #   :nested => label > input
  mattr_accessor :boolean_style
  @@boolean_style = :inline

  # You can define the class to use on all forms. Default is simple_form.
  mattr_accessor :form_class
  @@form_class = :simple_form

  # You can define which elements should obtain additional classes
  mattr_accessor :generate_additional_classes_for
  @@generate_additional_classes_for = [:wrapper, :label, :input]

  # Whether attributes are required by default (or not).
  mattr_accessor :required_by_default
  @@required_by_default = true

  # Tell browsers whether to use default HTML5 validations (novalidate option).
  mattr_accessor :browser_validations
  @@browser_validations = true

  # Collection of methods to detect if a file type was given.
  mattr_accessor :file_methods
  @@file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value, such as { /count/ => :integer }.
  mattr_accessor :input_mappings
  @@input_mappings = nil

  # Default priority for time_zone inputs.
  mattr_accessor :time_zone_priority
  @@time_zone_priority = nil

  # Default priority for country inputs.
  mattr_accessor :country_priority
  @@country_priority = nil

  # Maximum size allowed for inputs.
  mattr_accessor :default_input_size
  @@default_input_size = 50

  # When off, do not use translations in labels. Disabling translation in
  # hints and placeholders can be done manually in the wrapper API.
  mattr_accessor :translate_labels
  @@translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  mattr_accessor :inputs_discovery
  @@inputs_discovery = true

  # Cache SimpleForm inputs discovery
  mattr_accessor :cache_discovery
  @@cache_discovery = defined?(Rails) && !Rails.env.development?

  # Adds a class to each generated button, mostly for compatiblity
  mattr_accessor :button_class
  @@button_class = 'button'

  ## WRAPPER CONFIGURATION
  # The default wrapper to be used by the FormBuilder.
  mattr_accessor :default_wrapper
  @@default_wrapper = :default
  @@wrappers = {}

  # Retrieves a given wrapper
  def self.wrapper(name)
    @@wrappers[name.to_sym] or raise WrapperNotFound, "Couldn't find wrapper with name #{name}"
  end

  # Raised when fails to find a given wrapper name
  class WrapperNotFound < StandardError
  end

  # Define a new wrapper using SimpleForm::Wrappers::Builder
  # and store it in the given name.
  def self.wrappers(*args, &block)
    if block_given?
      options                 = args.extract_options!
      name                    = args.first || :default
      @@wrappers[name.to_sym] = build(options, &block)
    else
      @@wrappers
    end
  end

  # Builds a new wrapper using SimpleForm::Wrappers::Builder.
  def self.build(options={})
    options[:tag] = :div if options[:tag].nil?
    builder = SimpleForm::Wrappers::Builder.new(options)
    yield builder
    SimpleForm::Wrappers::Root.new(builder.to_a, options)
  end

  wrappers :class => :input, :hint_class => :field_with_hint, :error_class => :field_with_errors do |b|
    b.use :html5

    b.use :min_max
    b.use :maxlength
    b.use :placeholder
    b.optional :pattern
    b.optional :readonly

    b.use :label_input
    b.use :hint,  :wrap_with => { :tag => :span, :class => :hint }
    b.use :error, :wrap_with => { :tag => :span, :class => :error }
  end

  ## SETUP

  DEPRECATED = %w(hint_tag hint_class error_tag error_class error_notification_id wrapper_tag wrapper_class wrapper_error_class components html5)
  @@deprecated = []

  DEPRECATED.each do |method|
    class_eval "def self.#{method}=(*); @@deprecated << :#{method}=; end"
    class_eval "def self.#{method}; deprecation_warn 'SimpleForm.#{method} is deprecated and has no effect'; end"
  end

  def self.translate=(value)
    deprecation_warn "SimpleForm.translate= is disabled in favor of translate_labels="
    self.translate_labels = value
  end

  def self.translate
    deprecation_warn "SimpleForm.translate is disabled in favor of translate_labels"
    self.translate_labels
  end

  def self.deprecation_warn(message)
    ActiveSupport::Deprecation.warn "[SIMPLE_FORM] #{message}", caller
  end

  def self.additional_classes_for(component)
    generate_additional_classes_for.include?(component) ? yield : []
  end

  # Default way to setup SimpleForm. Run rails generate simple_form:install
  # to create a fresh initializer with all configuration values.
  def self.setup
    yield self

    unless @@deprecated.empty?
      raise "[SIMPLE FORM] Your SimpleForm initializer file is using the following methods: #{@@deprecated.to_sentence}. " <<
        "Those methods are part of the outdated configuration API. Updating to the new API is easy and fast. " <<
        "Check for more info here: https://github.com/plataformatec/simple_form/wiki/Upgrading-to-Simple-Form-2.0"
    end
  end
end
