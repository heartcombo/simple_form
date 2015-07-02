## 2.1.3

### bug fix
  * Fix method reflection for Ruby 2.1+. [@badosu](https://github.com/badosu)
  * Collection input generates `required` attribute if it has `prompt` option. [@nashby](https://github.com/nashby)
  * Use the given name in `input_html` for the hidden field in `collection_check_boxes` [@angelic](https://github.com/angelic)
  * Add "checkbox" class to the label of boolean input when there is no `:label`
  in `generate_additional_classes_for` config option [@nashby](https://github.com/nashby)
  * Support models with digits in their names [@webgago](https://github.com/webgago)

## 2.1.2

### bug fix
  * Fix XSS vulnerability on error components.

## 2.1.1

### bug fix
  * Fix XSS vulnerability on label, hint and error components.

## 2.1.0

### enhancements
  * `input_field` supports components that don't generate tags
    as `:min_max`, `:maxlength`, `:placeholder`, `:pattern`, `:readonly`.
    Closes [#362](https://github.com/plataformatec/simple_form/issues/632).
    ([@nashby](https://github.com/nashby))
  * support for Rails eager loading.
    Closes [#478](https://github.com/plataformatec/simple_form/issues/478).
  * generate required attribute for `date_time` input.
    ([@nashby](https://github.com/nashby))
    Closes [#730](https://github.com/plataformatec/simple_form/issues/730).
  * `grouped_collection_select` now accepts proc/lambda as label and value method.
    ([@svendahlstrand](https://github.com/svendahlstrand))
    Closes [#623](https://github.com/plataformatec/simple_form/issues/623).
  * Add Zurb Foundation 3 integration.
    ([@balexand](https://github.com/balexand))
  * Generates additional wrapper class based on object + attribute name.
    ([@lucasmazza](https://github.com/lucasmazza))
    Closes [#576](https://github.com/plataformatec/simple_form/issues/576).
  * Allow `input_field` to work with `:defaults` options.
    ([@smidwap](https://github.com/smidwap))

### bug fix
  * Do not lookup for hints if it was explicitly given false.
  After #405 we added hint classes for the wrappers, but this has forced the
  loading of the hint text doing I18n lookups, even though it was explicitly
  given false. This checks for the option in `#has_hint?`, avoiding the lookup
  in such cases. This issues has been caught with #627, thanks to
  ([@shwoodard](https://github.com/shwoodard)).
  * Fix default I18n lookup for association input.
  ([@nashby](https://github.com/nashby))
  Closes [#679](https://github.com/plataformatec/simple_form/issues/679).
  * Fix escaping issue in `label_input` component
  ([@allomov](https://github.com/allomov))

Please check [v2.0](https://github.com/plataformatec/simple_form/blob/v2.0/CHANGELOG.md) for previous changes.
