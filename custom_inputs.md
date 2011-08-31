---
layout: default
---

## Custom inputs

It is very easy to add custom inputs to SimpleForm. For instance, if you want to add a custom input that extends the string one, you just need to add this file:

    # app/inputs/currency_input.rb
    class CurrencyInput < SimpleForm::Inputs::Base
      def input
        "$ #{@builder.text_field(attribute_name, input_html_options)}".html_safe
      end
    end

And use it in your views:

    f.input :money, :as => :currency

You can also redefine existing SimpleForm inputs by creating a new class with the same name. For instance, if you want to wrap date/time/datetime in a div, you can do:

     # app/inputs/date_time_input.rb
     class DateTimeInput < SimpleForm::Inputs::DateTimeInput
       def input
         "<div>#{super}</div>".html_safe
       end
     end
