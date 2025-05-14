# frozen_string_literal: true

# These defaults are defined for CSS Zero
# Please submit feedback, changes and tests through proper channels.

# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/heartcombo/simple_form#custom-components
# to know more about custom components.
# Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config| # rubocop:disable Metrics/BlockLength
  # Default class for buttons
  # See: https://github.com/renuo/css-zero/blob/main/lib/generators/css_zero/add/templates/app/assets/stylesheets/button.css
  config.button_class = "btn"

  # Define the default class of the input wrapper of the boolean input.
  config.boolean_label_class = "checkbox"

  # How the label text should be generated altogether with the required text.
  config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }

  # Define the way to render check boxes / radio buttons with labels.
  config.boolean_style = :inline

  # You can wrap each item in a collection of radio/check boxes with a tag
  config.item_wrapper_tag = :div

  # Defines if the default input wrapper class should be included in radio
  # collection wrappers.
  config.include_default_input_wrapper_class = false

  # CSS class to add for error notification helper.
  # See: https://github.com/renuo/css-zero/blob/main/lib/generators/css_zero/add/templates/app/assets/stylesheets/input.css
  config.error_notification_class = "invalid-feedback"

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # add validation classes to `input_field`
  # See: https://github.com/renuo/css-zero/blob/main/lib/generators/css_zero/add/templates/app/assets/stylesheets/input.css
  config.input_field_error_class = "field_with_errors"
  config.input_field_valid_class = "field_without_errors"

  config.wrappers :default do |b|
    b.use :html5
  end

  # vertical forms
  #
  # vertical default_wrapper
  config.wrappers :vertical_form, class: "mbe-3" do |b|
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # vertical input for boolean
  config.wrappers :vertical_boolean, tag: "fieldset", class: "mbe-3" do |b|
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: "flex items-center" do |bb|
      bb.use :input, class: "checkbox", error_class: "field_with_errors", valid_class: "field_without_errors"
      bb.use :label, class: "mis-2"
      bb.use :error, wrap_with: { class: "invalid-feedback block" }
      bb.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # vertical input for radio buttons and check boxes
  config.wrappers :vertical_collection, item_wrapper_class: "flex items-center", item_label_class: "mis-2",
                                        tag: "fieldset", class: "mbe-3" do |b|
    b.optional :readonly
    b.wrapper :legend_tag, tag: "legend", class: "mbe-1" do |ba|
      ba.use :label_text
    end
    b.use :input, class: "radio", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # vertical input for inline radio buttons and check boxes
  config.wrappers :vertical_collection_inline, item_wrapper_class: "flex items-center mie-2",
                                               item_label_class: "mis-2", tag: "fieldset", class: "mbe-3" do |b|
    b.optional :readonly
    b.wrapper :legend_tag, tag: "legend", class: "mbe-1" do |ba|
      ba.use :label_text
    end
    b.use :input, class: "radio", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # vertical file input
  config.wrappers :vertical_file, class: "mbe-3" do |b|
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # vertical select input
  config.wrappers :vertical_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # vertical multi select
  config.wrappers :vertical_multi_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.wrapper class: "flex flex-col gap" do |ba|
      ba.use :input, class: "input mbe-2", error_class: "field_with_errors", valid_class: "field_without_errors"
    end
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # Date and time inputs
  config.wrappers :date_time_inputs, class: "mbe-3" do |b|
    b.use :placeholder
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.wrapper class: "flex flex-row gap" do |ba|
      ba.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
    end
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  # horizontal forms
  #
  # horizontal default_wrapper
  config.wrappers :horizontal_form, class: "flex flex-col mb-3" do |b|
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex flex-col" do |ba|
      ba.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # horizontal input for boolean
  config.wrappers :horizontal_boolean, class: "mbe-3" do |b|
    b.optional :readonly
    b.wrapper :grid_wrapper, class: "flex items-center" do |wr|
      wr.wrapper :form_check_wrapper, class: "flex items-center" do |bb|
        bb.use :input, class: "checkbox", error_class: "field_with_errors", valid_class: "field_without_errors"
        bb.use :label, class: "mis-2"
        bb.use :error, wrap_with: { class: "invalid-feedback block" }
        bb.use :hint, wrap_with: { class: "text-subtle" }
      end
    end
  end

  # horizontal input for radio buttons and check boxes
  config.wrappers :horizontal_collection, item_wrapper_class: "flex items-center", item_label_class: "mis-2",
                                          class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex flex-col" do |ba|
      ba.use :input, class: "radio", error_class: "field_with_errors", valid_class: "field_without_errors"
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # horizontal input for inline radio buttons and check boxes
  config.wrappers :horizontal_collection_inline, item_wrapper_class: "flex items-center mie-3",
                                                 item_label_class: "mis-2", class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex" do |ba|
      ba.use :input, class: "radio", error_class: "field_with_errors", valid_class: "field_without_errors"
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # horizontal file input
  config.wrappers :horizontal_file, class: "mbe-3" do |b|
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex flex-col" do |ba|
      ba.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # horizontal select input
  config.wrappers :horizontal_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex flex-col" do |ba|
      ba.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # horizontal multi select
  config.wrappers :horizontal_multi_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex flex-col" do |ba|
      ba.wrapper class: "flex flex-col gap" do |bb|
        bb.use :input, class: "input mbe-2", error_class: "field_with_errors", valid_class: "field_without_errors"
      end
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # inline forms
  #
  # inline default_wrapper
  config.wrappers :inline_form, class: "i-full" do |b|
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: "sr-only"

    b.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.optional :hint, wrap_with: { class: "text-subtle" }
  end

  # inline input for boolean
  config.wrappers :inline_boolean, class: "i-full" do |b|
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: "flex items-center" do |bb|
      bb.use :input, class: "checkbox", error_class: "field_with_errors", valid_class: "field_without_errors"
      bb.use :label, class: "mis-2"
      bb.use :error, wrap_with: { class: "invalid-feedback block" }
      bb.optional :hint, wrap_with: { class: "text-subtle" }
    end
  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    boolean: :vertical_boolean,
    check_boxes: :vertical_collection,
    date: :date_time_inputs,
    datetime: :date_time_inputs,
    file: :vertical_file,
    radio_buttons: :vertical_collection,
    range: :vertical_multi_select,
    time: :date_time_inputs,
    select: :vertical_select
  }
end
