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
