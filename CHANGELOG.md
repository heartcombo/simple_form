## todo

### enhancements

* Add bootstrap 4 initializer template.

## 3.2.1

* Updated gem dependency to support Rails 5.0.x.

## 3.2.0

### bug fix
  * Improve performance of input generation by disabling support for `_html` translations. This reverts the feature introduced on the 3.1.0 branch

## 3.1.1

### enhancements
  * Add the `disabled_class` to the label when the input is disabled. [@rhodrid](https://github.com/rhodrid)

### bug fix
  * Make it possible to override `required` value that was previously set in the wrapper. [@nashby](https://github.com/nashby)

  * `date/time/datetime` inputs now correctly generate the label `for` attribute when
  HTML5 compatibility is explicitly enabled. [@ericsullivan](https://github.com/ericsullivan)

  * The datetime, date, and time inputs now have a nice format by default on bootstrap.
  [@ulissesalmeida](https://github.com/ulissesalmeida) [@eltonchrls](https://github.com/eltonchrls)

  * Now it is possible to set custom input mappings for collections.

  Example:

  ```ruby
    # On configuration:
    config.input_mappings = { /gender$/ => :check_boxes }

    # On form:
    f.input :gender, collection: [:male, :female]
  ```
  [strangeworks](https://github.com/strangeworks)

## 3.1.0

### enhancements
  * Update foundation generator to version 5. [@jorge-d](https://github.com/jorge-d)
  * Add mapping to `uuid` columns.
  * Add custom namespaces for custom inputs feature. [@vala](https://github.com/vala)
  * Add `:unless_blank` option to the wrapper API. [@IanVaughan](https://github.com/IanVaughan)
  * Add support to html markup in the I18n options. [@laurocaetano](https://github.com/laurocaetano)
  * Add the `full_error` component. [@laurocaetano](https://github.com/laurocaetano)
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
  * `label_text` proc now receive three arguments (label, request, and if the label was explicit). [@timscott](https://github.com/timscott)
  * Add I18n support to `:include_blank` and `:prompt` when `:translate` is used as value. [@haines](https://github.com/plataformatec/simple_form/pull/616)
  * Add support to define custom error messages for the attributes.
  * Add support to change the I18n scope to be used in Simple Form. [@nielsbuus](https://github.com/nielsbuus)
  * The default form class can now be overridden with `html: { :class }`. [@rmm5t](https://github.com/rmm5t)

### bug fix
  * Fix `full_error` when the attribute is an association. [@mvdamme](https://github.com/jorge-d)
  * Fix suppport to `:namespace` and `:index` options for nested check boxes and radio buttons when the attribute is an association.
  * Collection input that uses automatic collection translation properly sets checked values.
  Closes [#971](https://github.com/plataformatec/simple_form/issues/971) [@nashby](https://github.com/nashby)
  * Collection input generates `required` attribute if it has `prompt` option. [@nashby](https://github.com/nashby)
  * Grouped collection uses the first non-empty object to detect label and value methods.

## deprecation
  * Methods on custom inputs now accept a required argument with the wrapper options.
  See https://github.com/plataformatec/simple_form/pull/997 for more information.
  * SimpleForm.form_class is deprecated in favor of SimpleForm.default_form_class.
  Future versions of Simple Form will not generate `simple_form` class for the form
  element.
  See https://github.com/plataformatec/simple_form/pull/1109 for more information.

Please check [v3.0](https://github.com/plataformatec/simple_form/blob/v3.0/CHANGELOG.md) for previous changes.
