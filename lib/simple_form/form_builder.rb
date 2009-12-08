require 'simple_form/label'
require 'simple_form/input'

module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    include SimpleForm::Label
    include SimpleForm::Input

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @options.assert_valid_keys(:as, :label, :options, :html)

      label = generate_label
      input = generate_input

      label << input
    end

  end
end
