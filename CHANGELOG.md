## master

### enhancements
  * Add support to `scope` to be used on associations. [@laurocaetano](https://github.com/laurocaetano)
  * Execute the association `condition` in the object context. [@laurocaetano](https://github.com/laurocaetano)
  * Check if the given association responds to `order` before calling it. [@laurocaetano](https://github.com/laurocaetano)
  * Add Bootstrap 3 initializer template.
  * For radio or checkbox collection always use `:item_wrapper_tag` to wrap the content and add `label` when using `boolean_style` with `:nested` [@kassio](https://github.com/kassio) and [@erichkist](https://github.com/erichkist)
  * `input_field` uses the same wrapper as input but only with attribute components. [@nashby](https://github.com/nashby)
  * Add wrapper mapping per form basis [@rcillo](https://github.com/rcillo) and [@bernardoamc](https://github.com/bernardoamc)
  * Add `for` attribute to `label` when collections are rendered as radio or checkbox [@erichkist](https://github.com/erichkist), [@ulissesalmeida](https://github.com/ulissesalmeida) and [@fabioyamate](https://github.com/fabioyamate)
  * Add `include_default_input_wrapper_class` config [@luizcosta](https://github.com/luizcosta)
  * Map `datetime`, `date` and `time` input types to their respective HTML5 input tags
  when the `:html5` is set to `true` [@volmer](https://github.com/volmer)
  * Add `boolean_label_class` config.
  * Add `:html` option to include additional attributes on custom wrappers [@remofritzsche](https://github.com/remofritzsche) and [@ulissesalmeida](https://github.com/ulissesalmeida)
  * Make possible to use the Wrappers API to define attributes for the components.
  See https://github.com/plataformatec/simple_form/pull/997 for more information.
  * Put a whitespace before the `inline_label` options of boolean input if it is present.
  * Add support to configure the `label_text` proc at the wrapper level. [@NOX73](https://github.com/NOX73)

### bug fix
  * Collection input that uses automatic collection translation properly sets checked values.
  Closes [#971](https://github.com/plataformatec/simple_form/issues/971) [@nashby](https://github.com/nashby)
  * Collection input generates `required` attribute if it has `prompt` option. [@nashby](https://github.com/nashby)
  * Grouped collection uses the first non-empty object to detect label and value methods.

## deprecation
  * Methods on custom inputs now accept a required argument with the wrapper options.
  See https://github.com/plataformatec/simple_form/pull/997 for more information.

## 3.0.1

### bug fix
  * Fix XSS vulnerability on label, hint and error components.

## 3.0.0

### enhancements
  * New `input_class` global config option to set a class to be generated in all inputs.
  * Collection tags accept html attributes as the last element of collection [@nashby](https://github.com/nashby)
  * Change default `:value_method` of collection tags from `:last` to `:second` [@nashby](https://github.com/nashby)
  * Support `Proc` object in `:conditions` option of associations [@bradly](https://github.com/bradly)
  * `input_field` supports `html5` component [@nashby](https://github.com/nashby)
  * Make `field_error_proc` configurable [@dfens](https://github.com/dfens)
  * Support to Rails 4.
  * Removed deprecated methods.
  * SimpleForm no longer sets the `size` attribute automatically and the `default_input_size` setting
  is now deprecated.
  * Support to aria-required attribute to required fields [@ckundo](https://github.com/ckundo)

### bug fix
  * Make `DateTimeInput#label_target` method to work with string values in `I18n.t('date.order')` (default
  behaviour in Rails 4)
  Closes [#846](https://github.com/plataformatec/simple_form/issues/846) [@mjankowski](https://github.com/mjankowski)
  * Add "checkbox" class to the label of boolean input when there is no `:label`
  in `generate_additional_classes_for` config option [@nashby](https://github.com/nashby)
  * Support models with digits in their names [@webgago](https://github.com/webgago)
  * Remove deprecation warnings related to `Relation#all` from Rails 4.
  * Form builder can be used outside the context of a controller [@jasonwebster](https://github.com/jasonwebster)
  * Skip pattern attribute when using `validates_format_of` with `:without` option [@glebm](https://github.com/glebm)

Please check [v2.1](https://github.com/plataformatec/simple_form/blob/v2.1/CHANGELOG.md) for previous changes.
