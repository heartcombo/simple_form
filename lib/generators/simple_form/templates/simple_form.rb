# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Components used by the form builder to generate a complete input. You can remove
  # any of them, change the order, or even add your own components to the stack.
  # config.components = [ :placeholder, :label_input, :hint, :error ]

  # Default tag used on hints.
  # config.hint_tag = :span

  # CSS class to add to all hint tags.
  # config.hint_class = :hint

  # Default tag used on errors.
  # config.error_class = :error

  # Default tag used on errors.
  # config.error_tag = :span

  # Method used to tidy up errors.
  # config.error_method = :first

  # Default tag used for error notification helper.
  # config.error_notification_tag = :p

  # CSS class to add for error notification helper.
  # config.error_notification_class = :error_notification

  # ID to add for error notification helper.
  # config.error_notification_id = nil

  # You can wrap all inputs in a pre-defined tag.
  # config.wrapper_tag = :div

  # CSS class to add to all wrapper tags.
  # config.wrapper_class = :input

  # CSS class to add to the wrapper if the field has errors.
  # config.wrapper_error_class = :field_with_errors

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can wrap each item in a collection of radio/check boxes with a tag, defaulting to none.
  # config.item_wrapper_tag = nil

  # Series of attemps to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required| "#{required} #{label}" }

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :file?, :public_filename ]

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # Default size for text inputs.
  # config.default_input_size = 50

  # When false, do not use translations for labels, hints or placeholders.
  # config.translate = true
end
