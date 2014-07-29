# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Don't forget to edit this file to adapt to your needs (specially
  # all the grid-related classes)

  config.wrappers :vertical_foundation, class: :input, hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :error, wrap_with: { tag: :small, class: :error }

    # Uncomment the following line to enable hints. The line is commented out by default since Foundation
    # does't provide styles for hints. You will need to provide your own CSS styles for hints.
    # b.use :hint,  wrap_with: { tag: :span, class: :hint }
  end

  config.wrappers :horizontal_form, tag: 'div', class: 'row', hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: 'small-3 columns' do |ba|
      ba.use :label, class: 'right inline'
    end

    b.wrapper :right_input_wrapper, tag: :div, class: 'small-9 columns' do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :small, class: :error }
      ba.use :hint,  wrap_with: { tag: :span, class: :hint }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: 'div', class: 'row' do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :container_wrapper, tag: 'div', class: 'small-offset-3 small-9 columns' do |ba|
      ba.wrapper :tag => 'label', :class => 'checkbox' do |bb|
        bb.use :input
        bb.use :label_text
      end

      ba.use :error, wrap_with: { tag: :small, class: :error }
      # ba.use :hint,  wrap_with: { tag: :span, class: :hint }
    end
  end

  config.wrappers :inline_form, tag: 'div', class: 'column small-4', hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.use :label, class: 'hidden-for-small-up'
    b.use :input

    b.use :error, wrap_with: { tag: :small, class: :error }
    # b.use :hint,  wrap_with: { tag: :span, class: :hint }
  end

  # Example of use:
  # - wrapper_html: {class: 'row'}, custom_wrapper_html: {class: 'column small-12'}
  # - custom_wrapper_html: {class: 'column small-3 end'}
  config.wrappers :foundation_customizable_wrapper, tag: 'div', error_class: :error do |b|
    b.use :html5
    b.optional :readonly

    b.wrapper :custom_wrapper, tag: :div do |ba|
      ba.use :label_input
    end

    b.use :error, wrap_with: { tag: :small, class: :error }
    # b.use :hint,  wrap_with: { tag: :span, class: :hint }
  end

  # CSS class for buttons
  config.button_class = 'button'

  # Set this to div to make the checkbox and radio properly work
  # otherwise simple_form adds a label tag instead of a div arround
  # the nested label
  config.item_wrapper_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert-box alert'

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_foundation
end
