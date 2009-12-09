require 'simple_form/builder_extensions'
require 'simple_form/form_helper'
require 'simple_form/form_builder'

ActionView::Helpers::FormBuilder.send :include, SimpleForm::BuilderExtensions