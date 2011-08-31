---
layout: default
---

## HTML 5 Notice

By default, SimpleForm will generate input field types and attributes that are supported in HTML5, but are considered invalid HTML for older document types such as HTML4 or XHTML1.0. The HTML5 extensions include the new field types such as email, number, search, url, tel, and the new attributes such as required, autofocus, maxlength, min, max, step.

Most browsers will not care, but some of the newer ones - in particular Chrome 10+ - use the required attribute to force a value into an input and will prevent form submission without it. Depending on the design of the application this may or may not be desired. In many cases it can break existing UI's.

It is possible to disable all HTML 5 extensions in SimpleForm with the following configuration:

    SimpleForm.html5 = false # default is true

If you want to have all other HTML 5 features, such as the new field types, you can disable only the browser validation:

    SimpleForm.browser_validations = false # default is true

This option adds a new `novalidate` property to the form, instructing it to skip all HTML 5 validation. The inputs will still be generated with the required and other attributes, that might help you to use some generic javascript validation.

You can also add `novalidate` to a specific form by setting the option on the form itself:

    <%= simple_form_for(resource, :html => {:novalidate => true}) do |form| %>

Please notice that any of the configurations above will disable the `placeholder` component, which is an HTML 5 feature. We believe most of the newest browsers are handling this attribute fine, and if they aren't, any plugin you use would take of using the placeholder attribute to do it. However, you can disable it if you want, by removing the placeholder component from the components list in SimpleForm configuration file.
