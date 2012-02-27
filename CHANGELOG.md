## 2.0.1

### bug fix
  * Sanitaze html attributes to `label` method. ([@nashby](https://github.com/nashby)).
  Closes [#472](https://github.com/plataformatec/simple_form/issues/472)
  * Make `collection_check_boxes` and `collection_radio_buttons` work with local variables.
  Closes [#474](https://github.com/plataformatec/simple_form/issues/474)
  * Use `html5` component by default in the bootstrap generator. ([@isc](https://github.com/isc)).
  Closes [#471](https://github.com/plataformatec/simple_form/issues/471)

## 2.0.0

### enhancements
  * Add `button_class` configuration to change the class of buttons. ([@sryche](https://github.com/sryche))
  * Add `disabled` class to a disabled input.
  * Generate configuration file with `browser_validations` disabled.
  * Add option and configuration to specify the collection wrapper class. ([@mfila](https://github.com/mfila))
  * Add proc support to `collection` option. ([@jeffkreeftmeijer](https://github.com/jeffkreeftmeijer))
  * `simple_form_for` allows default options for its inputs `:defaults => {}`.
  * Add `readonly` as option of input method. ([@Untainted123](https://github.com/Untainted123))
  * `simple_fields_for` for inherits wrapper option form the form builder. ([@nashby](https://github.com/nashby))
  * Use action prefix in the form css class. Closes [#360](https://github.com/plataformatec/simple_form/issues/360).
    This is not backward compatible with the previous versions of SimpleForm.
    For more informations see [this comment](https://github.com/plataformatec/simple_form/issues/360#issuecomment-3000780).
    ([@nashby](https://github.com/nashby))
  * Add a readonly component that does automatically readonly lookup from object
  * Add support for proc or lambda as option for format validator ([@nashby](https://github.com/nashby))
  * Handle validates_length_of :is option in maxlength ([@nashby](https://github.com/nashby))
  * Add field_with_hint css class to the wrapper when the input has a hint, similar to field_with_errors ([@nashby](https://github.com/nashby))
  * Add :grouped_select input type, mapping to Rails grouped_collection_select helper ([@semaperepelitsa](https://github.com/semaperepelitsa))
  * Add automatic translation of options for collection inputs given a collection of symbols ([@klobuczek](https://github.com/klobuczek))
  * Add `:boolean_style` config to change how check boxes and radios will be displayed.
    Options are `:inline = input + label` (default) and `:nested = label > input`.
  * Add possibility to give a block to `collection_radio` and `collection_check_boxes`,
    yielding a custom builder to generate custom label and input structure. It
    is used internally with the :nested option for `:boolean_style`, and is useful
    to allow some more customization if required.
  * Do not generate hidden check box field when using nested boolean style, as it is considered
    invalid markup in HTML5. This will work by default in Rails > 3.2.1 (not released at this time),
    and is backported inside SimpleForm builder extensions.
    More info in [#215](https://github.com/plataformatec/simple_form/issues/215)
  * Add `item_wrapper_class` configuration option for collection radio buttons / check boxes inputs.
  * Change default generator templates to use .form-inputs and .form-actions classes in wrapper divs.
    (the latter is the default in bootstrap, so this makes it easier to integrate).
  * Field error now accepts HTML tags ([@edison](https://github.com/edison))
  * Add `generate_additional_classes_for` config option to selectively disable extra
    css classes for components - wrapper, label and input. ([krzyzak](https://github.com/krzyzak))

### deprecation
  * Deprecate part of the old configuration API in favor of the wrapper API which allows you to customize your inputs
    in a more flexible way. See [this guide](https://github.com/plataformatec/simple_form/wiki/Upgrading-to-Simple-Form-2.0)
    to know how upgrade.
  * Deprecate the `translate` configuration in favor of `translate_labels`
  * Deprecate the `html5` configuration in favor of a new `html5` component
  * Deprecate `:radio` input type in favor of `:radio_buttons`
  * Deprecate `collection_radio` form helper in favor of `collection_radio_buttons`
    (the label class has changed as well)
  * Remove `error_notification_id` configuration

### bug fix
  * Fix i18n lookup with attributes with same name of models.
    Closes [#149](https://github.com/plataformatec/simple_form/issues/149)
    and [#364](https://github.com/plataformatec/simple_form/issues/364).
    ([@nashby](https://github.com/nashby) and [@MarceloCajueiro](https://github.com/MarceloCajueiro))
  * Do not generate `for` attribute for the collection label when it is a checkbox or radio.
    Closes [#344](https://github.com/plataformatec/simple_form/issues/344).
    ([@nashby](https://github.com/nashby) and [@mfila](https://github.com/mfila))
  * Select can have required option when the `:include_blank` option is passed.
    Closes [#340](https://github.com/plataformatec/simple_form/issues/340). ([@nashby](https://github.com/nashby))
  * `:checked` option should override the existing associations on `collection_check_boxes`.
    Closes [#341](https://github.com/plataformatec/simple_form/issues/341). ([@nashby](https://github.com/nashby))
  * Move default attribute translations out of root - use "defaults" key instead
    Closes [#384](https://github.com/plataformatec/simple_form/issues/384). ([@fringd](https://github.com/fringd))
  * Fix label to datetime inputs to point to first select. ([@georgehemmings](https://github.com/georgehemmings))
  * Fix usage of f.button :button with Rails 3.2.
    Closes [#449](https://github.com/plataformatec/simple_form/issues/449).

## 1.5.2

### bug fix
  * Remove the internal usage of deprecated `:components`

## 1.5.1

### deprecation
  * `:components` options is now deprecated

### bug fix
  * Fallback to default label when block is provided. ([@pivotal-casebook](https://github.com/pivotal-casebook))
  * Do not override default selection through attribute value in collection select when label/value methods are lambdas.

## 1.5.0

### enhancements
  * Simplified generator by using directory action. ([@rupert654](https://github.com/rupert654))
  * Support for `maxlength` on string inputs inferred from validation. ([@srbartlett](https://github.com/srbartlett))
  * Change form css class handling to only add the dom class when one is not given to the form call.
    ([@patrick99e99](https://github.com/patrick99e99))
  * Support for required attributes when action validations are present. ([@csegura](http://github.com/csegura))
  * Do not generate `size` attribute for numeric input. ([@csegura](https://github.com/jasonmp85))
  * Support for `maxlength` on text area inputs inferred from validation.
  * Support for `pattern` on text field inferred from validation when `:pattern` is true.
  * Break Text, Password and File into their own inputs.
  * Support easy enabling and disabling of components for specific inputs.
  * Add HTML5 range input.

### bug fix
  * Fix bug when `simple_fields_for` is used with a hash like models and Rails 3.1.
  * Fix bug that does not remove the `:item_wrapper_tag` or the `:collection_wrapper_tag` on collection
    inputs when nil or false value is passed to these options. ([@dw2](https://gitbub.com/dw2))
  * Fix bug that disable the entire select and wrapper when `disabled` option is a string or array.
  * Fix bug when using label/value methods as procs together with disabled/selected options as procs for select inputs.

## 1.4.2

### enhancements
  * Rails 3.1 support.

## 1.4.1

### enhancements
  * ignore required attribute when conditional validations are present.

### bug fix
  * Do not use `required='required'` when browser validations are turned off.
  * Sanitize HMTL attributes in error and hint helpers when options are present.
  * Improve i18n lookup by ignoring explicit child index given to form builder.
    (tests by [@rywall](https://github.com/rywall))
  * Fixes the form specific validation option if specified on the form itself. ([@medihack](https://github.com/medihack))

## 1.4.0

### enhancements
  * Add label class configuration option. ([@reu](http://github.com/reu))
  * Improve i18n lookup (labels/hints/placeholders) for nested models.
  * Use the given custom builder with `simple_fields_for`. ([@giniedp](https://github.com/giniedp))
  * Add slim form generator. ([@fagiani](https://github.com/fagiani))
  * Add `form_class` configuration option. ([@fagiani](https://github.com/fagiani))
  * Default step of `any` for number input with non integer attributes. ([@fedesoria](https://github.com/fedesoria))
  * Add option to disable HTML5 browser validations on all forms. ([@coryschires](https://github.com/coryschires))
  * Add option to disable all HTML5 extensions. ([@wolframarnold](https://github.com/wolframarnold))
  * Add `input_field` helper to form builder. ([@jeroenhouben](https://github.com/jeroenhouben))
  * Allow inputs to be discovered on demand by placing them at app/inputs (a la formtastic).
  * Add `full_error` on that shows the error with the attribute name.

### bug fix
  * Fix for file attributes automatic detection, to work with virtual attributes.
  * Fix for numeric fields validation options using symbols and procs.
  * Fix password attributes to add `size` and `maxlength` options the same way as string. ([@fedesoria](https://github.com/fedesoria))
  * Fix bug with custom form builders and new mappings being added to the superclass builder. ([@rdvdijk](https://github.com/rdvdijk))
  * Fix HTML validation issue with `collection_check_boxes`.

## 1.3.1

### enhancements
  * Add `:autofocus` HTML5 attribute support. ([@jpzwarte](https://github.com/jpzwarte))
  * Add possibility to specify custom builder and inherit mappings. ([@rejeep](https://github.com/rejeep))
  * Make custom mappings work with all attributes types. ([@rafaelfranca](https://github.com/rafaelfranca))
  * Add support for procs/lambdas in text/value methods for `collection_select`.

### deprecation
  * removed the deprecated `:remote_form_for`

### bug fix
  * Only add the `required` HTML 5 attribute for valid inputs, disable in selects (not allowed).
  * Fix error when using hints without an attribute.
    ([@butsjoh](https://github.com/butsjoh) and [@rafaelfranca](https://github.com/rafaelfranca))
  * Fix messy html output for hint, error and label components.
    ([@butsjoh](https://github.com/butsjoh) and [@rafaelfranca](https://github.com/rafaelfranca))
  * Allow direct setting of for attribute on label. ([@Bertg](https://github.com/Bertg))

## 1.3.0

### enhancements
  * Allow collection input to accept a collection of symbols.
  * Add default css class to button.
  * Allow forms for objects that do not respond to the `errors` method.
  * `collection_check_boxes` and `collection_radio` now wrap the input in the label.
  * Automatic add min/max values for numeric attributes based on validations and step for integers - HTML5.
    ([@dasch](https://github.com/dasch))
  * Add `:placeholder` option for string inputs, allowing customization through I18n - HTML5.
    ([@jonathan](https://github.com/jonathan))
  * Add `:search` and `:tel` input types, with `:tel` mapping automatically from attributes matching "phone" - HTML5.
  * Add `:required` html attribute for required inputs - HTML5.
  * Add optional `:components` option to input to control component rendering. ([@khoan](https://github.com/khoan))
  * Add `SimpleForm.translate` as an easy way to turn off SimpleForm internal translations.
  * Add `:disabled` option for all inputs. ([@fabiob](https://github.com/fabiob))
  * Add collection wrapper tag and item wrapper tag to wrap elements in collection helpers - radio / check boxes.
  * Add `SimpleForm.input_mappings` to allow configuring custom mappings for inputs. ([@TMaYaD](https://github.com/TMaYaD))

### bug fix
  * Search for validations on both association and attribute.
  * Use `controller.action_name` to lookup action only when available, to fix issue with Rspec views tests.
    ([@rafaelfranca](https://github.com/rafaelfranca))

## 1.2.2

### enhancements
  * Compatibility with Rails 3 RC.

## 1.2.1

### enhancements
  * Added haml generator support. ([@grimen](https://github.com/grimen))
  * Added `error_notification` message to form builder.
  * Added required by default as configuration option.
  * Added `label_input` as component, allowing boolean to change its order (input appearing first than label).
  * Added `error_method` to tidy up how errors are exhibited.
  * Added error class on wrappers. ([@jduff](https://github.com/jduff))
  * Changed numeric types to have `type=number` for HTML5.

## 1.2.0

### deprecation
  * Changed `simple_form_install` generator to `simple_form:install`.

### enhancements
  * Added support to presence validation to check if attribute is required or not. ([@gcirne](https://github.com/gcirne))
  * Added `input` as class to wrapper tag.
  * Added config options for hint and error tags. ([@tjogin](https://github.com/tjogin))

## 1.1.3

### deprecation
  * removed `:conditions`, `:order`, `:joins` and `:include` support in `f.association`.

## 1.1.2

### bug fix
  * Ensure type is set to "text" and not "string".

## 1.1.1

### bug fix
  * Fix some escaping issues.

## 1.1.0

### enhancements
  * Rails 3 support with generators, templates and HTML 5.

## 1.0

* First release.
