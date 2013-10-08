# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|

  config.wrappers :pure, tag: 'div', class: 'pure-control-group', error_class: 'error' do |b|

    b.optional :readonly
    b.optional :disabled
    b.optional :required

    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: :small }

    # Uncomment the following line to enable hints. The line is commented out by default since Pure
    # does't provide styles for hints. You will need to provide your own CSS styles for hints.
    # b.use :hint,  wrap_with: { tag: :span, class: :hint }

  end

  # CSS class for buttons
  config.button_class = 'pure-button pure-button-primary'

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :pure

end