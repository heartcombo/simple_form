---
layout: default
---

## Custom form builder

You can create a custom form builder that uses SimpleForm.

Create a helper method that calls simple_form_for with a custom builder:

    def custom_form_for(object, *args, &block)
      options = args.extract_options!
      simple_form_for(object, *(args << options.merge(:builder => CustomFormBuilder)), &block)
    end

Create a form builder class that inherits from SimpleForm::FormBuilder.

    class CustomFormBuilder < SimpleForm::FormBuilder
      def input(attribute_name, options = {}, &block)
        options[:input_html].merge! :class => 'custom'
        super
      end
    end
