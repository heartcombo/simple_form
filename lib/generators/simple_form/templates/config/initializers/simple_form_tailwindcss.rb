# frozen_string_literal: true

# Please do not make direct changes to this file!
# The generator is written by author named 'loqimean'
# All future development, tests, and organization should happen there.
# Background history: https://github.com/heartcombo/simple_form/issues/1561

# Uncomment this and change the path if necessary to include your own
# components.
# See https://github.com/heartcombo/simple_form#custom-components
# to know more about custom components.
# Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :vertical_form, tag: 'div', class: 'mb-3', error_class: 'form-group-invalid',
                                  valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.use :placeholder, class: 'text-gray-400'
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'ml-1 mb-2'
    b.use :input,
          class: 'mt-1 focus:ring-indigo-500 focus:border-indigo-500 ' \
                 'block w-full shadow-sm sm:text-sm border-gray-300 rounded-md',
          error_class: 'border-red-400 is-invalid mb-1', valid_class: 'is-valid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
    b.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
  end

  # vertical input for radio buttons and check boxes
  config.wrappers :vertical_collection, item_wrapper_class: 'form-check',
                                        item_label_class: 'form-check-label',
                                        tag: 'fieldset',
                                        class: 'form-group mb-3',
                                        error_class: 'form-group-invalid',
                                        valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
      ba.use :label_text, class: 'ml-3 block text-sm font-medium text-gray-700'
    end
    b.use :input, class: 'focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 mr-2',
                  error_class: 'is-invalid border-red-400',
                  valid_class: 'is-valid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
    b.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
  end

  # vertical input for radio buttons and check boxes
  # config.wrappers :vertical_check_boxes_collection, item_wrapper_class: 'form-check',
  #                                                   item_label_class: 'form-check-label',
  #                                                   tag: 'fieldset', class: 'form-group mb-3',
  #                                                   error_class: 'form-group-invalid',
  #                                                   valid_class: 'form-group-valid' do |b|
  #   b.use :html5
  #   b.optional :readonly
  #   b.wrapper :legend_tag, tag: 'legend', class: 'col-form-label pt-0' do |ba|
  #     ba.use :label_text, class: 'ml-3 block text-sm font-medium text-gray-700'
  #   end
  #   b.use :input, class: 'focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2',
  #                 error_class: 'is-invalid border-red-400',
  #                 valid_class: 'is-valid'
  #   b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
  #   b.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
  # end

  # horizontal input for inline radio buttons and check boxes
  config.wrappers :horizontal_collection_inline, item_wrapper_class: 'form-check form-check-inline',
                                                 item_label_class: 'form-check-label',
                                                 tag: 'div',
                                                 class: 'form-group flex flex-row-reverse w-fit mb-3',
                                                 error_class: 'form-group-invalid',
                                                 valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'pt-0 mb-2'
    b.wrapper :grid_wrapper, tag: 'div' do |ba|
      ba.use :input, class: 'focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2',
                     error_class: 'is-invalid', valid_class: 'is-valid'
      ba.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
      ba.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
    end
  end

  # vertical multi select
  config.wrappers :vertical_multi_select, tag: 'div', class: 'mb-3',
                                                      error_class: 'form-group-invalid',
                                                      valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label, class: 'mb-2'
    b.wrapper tag: 'div', class: 'flex flex-col md:flex-row gap-1 justify-between items-center' do |ba|
      ba.use :input, class: 'w-full min-w-fit mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md',
                     error_class: '!border-red-500',
                     valid_class: 'is-valid'
    end
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
    b.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
  end

  # vertical input for boolean
  config.wrappers :vertical_boolean, tag: 'fieldset', class: 'mb-3',
                                                      error_class: 'form-group-invalid',
                                                      valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.optional :readonly
    b.wrapper :form_check_wrapper, tag: 'div' do |bb|
      bb.use :input, class: 'focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded mr-2',
                     error_class: '!border-red-500',
                     valid_class: 'is-valid'
      bb.use :label, class: 'mb-2'
    end
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
    b.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
  end

  # vertical file input
  config.wrappers :vertical_file, tag: 'div',
                                  class: 'form-group',
                                  error_class: 'form-group-invalid',
                                  valid_class: 'form-group-valid' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :readonly
    b.use :label, class: 'mb-2'
    b.use :input, class: 'w-full min-w-fit mt-1 focus:ring-indigo-500 focus:border-indigo-500 block shadow-sm sm:text-sm border-gray-300 rounded-md border',
                  error_class: 'border-red-400 is-invalid mb-1',
                  valid_class: 'is-valid'
    b.use :full_error, wrap_with: { tag: 'div', class: 'invalid-feedback text-xs text-red-400' }
    b.use :hint, wrap_with: { tag: 'small', class: 'text-gray-400' }
  end

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = {
    boolean: :vertical_boolean,
    check_boxes: :vertical_collection,
    date: :vertical_multi_select,
    file: :vertical_file,
    datetime: :vertical_multi_select,
    radio_buttons: :vertical_collection,
    time: :vertical_multi_select
  }

  # How the label text should be generated altogether with the required text.
  config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }

  # CSS class for buttons
  config.button_class = 'rounded-lg py-3 px-5 bg-blue-600 text-white inline-block font-medium cursor-pointer mb-1'

  # Set this to div to make the checkbox and radio properly work
  # otherwise simple_form adds a label tag instead of a div around
  # the nested label
  config.item_wrapper_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # :to_sentence to list all errors for each field.
  config.error_method = :to_sentence

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form

  # add validation classes to `input_field`
  config.input_field_error_class = 'is-invalid'
  config.input_field_valid_class = 'is-valid'
end
