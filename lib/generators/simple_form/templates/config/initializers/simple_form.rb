# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Wrappers are used by the form builder to generate a complete input.
  # You can remove any component from the wrapper, change the order or even
  # add your own to the stack. The options given to the wrappers method
  # are used to wrap the whole input (if any exists).
  config.wrappers :class => :input, :error_class => :field_with_errors do |b|
    b.use :placeholder
    b.use :label_input
    b.use :hint,  :tag => :span, :class => :hint
    b.use :error, :tag => :span, :class => :error
  end

  # Method used to tidy up errors.
  # config.error_method = :first

  # Default tag used for error notification helper.
  # config.error_notification_tag = :p

  # CSS class to add for error notification helper.
  # config.error_notification_class = :error_notification

  # ID to add for error notification helper.
  # config.error_notification_id = nil

  # Series of attempts to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can wrap each item in a collection of radio/check boxes with a tag, defaulting to span.
  # config.item_wrapper_tag = :span

  # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  # config.label_class = nil

  # You can define the class to use on all forms. Default is simple_form.
  # config.form_class = :simple_form

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Tell browsers whether to use default HTML5 validations (novalidate option).
  # Default is enabled.
  config.browser_validations = false

  # Determines whether HTML5 types (:email, :url, :search, :tel) and attributes
  # (e.g. required) are used or not. True by default.
  # Having this on in non-HTML5 compliant sites can cause odd behavior in
  # HTML5-aware browsers such as Chrome.
  # config.html5 = true

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # Default size for text inputs.
  # config.default_input_size = 50

  # When false, do not use translations for labels, hints or placeholders.
  # config.translate = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache simple form inputs discovery
  # config.cache_discovery = !Rails.env.development?

  # Default class for buttons
  # config.button_class = 'button'
end
