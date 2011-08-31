---
layout: default
---

## Extra helpers

SimpleForm also comes with some extra helpers you can use inside rails default forms without relying on simple_form_for helper. They are listed below.

### Simple Fields For

Wrapper to use simple form inside a default rails form

    form_for @user do |f|
      f.simple_fields_for :posts do |posts_form|
        # Here you have all simple_form methods available
        posts_form.input :title
      end
    end

### Collection Radio

Creates a collection of radio inputs with labels associated (same API as collection_select):

    form_for @user do |f|
      f.collection_radio :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
    end

    <input id="user_options_true" name="user[options]" type="radio" value="true" />
    <label class="collection_radio" for="user_options_true">Yes</label>
    <input id="user_options_false" name="user[options]" type="radio" value="false" />
    <label class="collection_radio" for="user_options_false">No</label>

### Collection Check Box

Creates a collection of check boxes with labels associated (same API as collection_select):

    form_for @user do |f|
      f.collection_check_boxes :options, [[true, 'Yes'] ,[false, 'No']], :first, :last
    end

    <input name="user[options][]" type="hidden" value="" />
    <input id="user_options_true" name="user[options][]" type="checkbox" value="true" />
    <label class="collection_check_box" for="user_options_true">Yes</label>
    <input name="user[options][]" type="hidden" value="" />
    <input id="user_options_false" name="user[options][]" type="checkbox" value="false" />
    <label class="collection_check_box" for="user_options_false">No</label>

To use this with associations in your model, you can do the following:

    form_for @user do |f|
      f.collection_check_boxes :role_ids, Role.all, :id, :name # using :roles here is not going to work.
    end
