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
  config.button_class = "btn"
  config.boolean_label_class = "checkbox"
  config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }
  config.boolean_style = :inline
  config.item_wrapper_tag = :div
  config.include_default_input_wrapper_class = false
  config.error_notification_class = "invalid-feedback"
  config.error_method = :to_sentence
  config.input_field_error_class = "field_with_errors"
  config.input_field_valid_class = "field_without_errors"

  config.wrappers :default do |b|
    b.use :html5
  end

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

  config.wrappers :vertical_boolean, tag: "fieldset", class: "mbe-3" do |b|
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: "flex items-center" do |bb|
      bb.use :input, class: "checkbox", error_class: "field_with_errors", valid_class: "field_without_errors"
      bb.use :label, class: "mis-2"
      bb.use :error, wrap_with: { class: "invalid-feedback block" }
      bb.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

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

  config.wrappers :vertical_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

  config.wrappers :vertical_multi_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-1"
    b.wrapper class: "flex flex-col gap" do |ba|
      ba.use :input, class: "input mbe-2", error_class: "field_with_errors", valid_class: "field_without_errors"
    end
    b.use :error, wrap_with: { class: "invalid-feedback block" }
    b.use :hint, wrap_with: { class: "text-subtle" }
  end

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

  config.wrappers :horizontal_select, class: "mbe-3" do |b|
    b.optional :readonly
    b.use :label, class: "mbe-2"
    b.wrapper :grid_wrapper, class: "flex flex-col" do |ba|
      ba.use :input, class: "input", error_class: "field_with_errors", valid_class: "field_without_errors"
      ba.use :error, wrap_with: { class: "invalid-feedback block" }
      ba.use :hint, wrap_with: { class: "text-subtle" }
    end
  end

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

  config.wrappers :inline_boolean, class: "i-full" do |b|
    b.optional :readonly
    b.wrapper :form_check_wrapper, class: "flex items-center" do |bb|
      bb.use :input, class: "checkbox", error_class: "field_with_errors", valid_class: "field_without_errors"
      bb.use :label, class: "mis-2"
      bb.use :error, wrap_with: { class: "invalid-feedback block" }
      bb.optional :hint, wrap_with: { class: "text-subtle" }
    end
  end

  config.default_wrapper = :vertical_form

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
