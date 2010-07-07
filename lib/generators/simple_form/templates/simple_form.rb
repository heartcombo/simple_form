# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  # Components used by the form builder to generate a complete input. You can remove
  # any of them, change the order, or even add your own components to the stack.
  # config.components = [ :label_input, :hint, :error ]

  # Default tag used on hints.
  # config.hint_tag = :span

  # Default tag used on errors.
  # config.error_tag = :span

  # Method used to tidy up errors.
  # config.error_method = :first

  # Default tag used for error notification helper.
  # config.error_notification_tag = :p

  # You can wrap all inputs in a pre-defined tag.
  # config.wrapper_tag = :div

  # CSS class to add to all wrapper tags.
  # config.wrapper_class = :input

  # CSS class to add to the wrapper if the field has errors.
  # config.wrapper_error_class = :field_with_errors

  # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required| "#{required} #{label}" }

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Series of attemps to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attemps to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :file?, :public_filename ]

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # Default size for text inputs.
  # config.default_input_size = 50
end
