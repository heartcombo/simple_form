---
layout: default
---

## Usage

SimpleForm was designed to be customized as you need to. Basically it's a stack of components that are invoked to create a complete html input for you, which by default contains label, hints, errors and the input itself. It does not aim to create a lot of different logic from the default Rails form helpers, as they do a great work by themselves. Instead, SimpleForm acts as a DSL and just maps your input type (retrieved from the column definition in the database) to an specific helper method.

To start using SimpleForm you just have to use the helper it provides:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username %>
      <%= f.input :password %>
      <%= f.button :submit %>
    <% end %>

This will generate an entire form with labels for user name and password as well, and render errors by default when you render the form with invalid data (after submitting for example).

You can overwrite the default label by passing it to the input method, add a hint or even a placeholder:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username, :label => 'Your username please' %>
      <%= f.input :password, :hint => 'No special characters.' %>
      <%= f.input :email, :placeholder => 'user@domain.com' %>
      <%= f.button :submit %>
    <% end %>

You can also disable labels, hints or error or configure the html of any of them:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username, :label_html => { :class => 'my_class' } %>
      <%= f.input :password, :hint => false, :error_html => { :id => "password_error"} %>
      <%= f.input :password_confirmation, :label => false %>
      <%= f.button :submit %>
    <% end %>

It is also possible to pass any html attribute straight to the input, by using the :input_html option, for instance:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username, :input_html => { :class => 'special' } %>
      <%= f.input :password, :input_html => { :maxlength => 20 } %>
      <%= f.input :remember_me, :input_html => { :value => '1' } %>
      <%= f.button :submit %>
    <% end %>

By default all inputs are required, which means an * is prepended to the label, but you can disable it in any input you want:

    <%= simple_form_for @user do |f| %>
      <%= f.input :name, :required => false %>
      <%= f.input :username %>
      <%= f.input :password %>
      <%= f.button :submit %>
    <% end %>

SimpleForm also lets you overwrite the default input type it creates:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username %>
      <%= f.input :password %>
      <%= f.input :description, :as => :text %>
      <%= f.input :accepts,     :as => :radio %>
      <%= f.button :submit %>
    <% end %>

So instead of a checkbox for the :accepts attribute, you'll have a pair of radio buttons with yes/no labels and a text area instead of a text field for the description. You can also render boolean attributes using :as => :select to show a dropdown.

It is also possible to give the :disabled option to SimpleForm, and it'll automatically mark the wrapper as disabled with a css class, so you can style labels, hints and other components inside the wrapper as well:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username, :disabled => true, :hint => "You cannot change your username." %>
      <%= f.button :submit %>
    <% end %>

SimpleForm accepts same options as their corresponding input type helper in Rails:

    <%= simple_form_for @user do |f| %>
      <%= f.input :date_of_birth, :as => :date, :start_year => Date.today.year - 90,
                                :end_year => Date.today.year - 12, :discard_day => true,
                                :order => [:month, :year] %>
      <%= f.button :submit %>
    <% end %>

SimpleForm also allows you to use label, hint, input_field, error and full_error helpers it provides (please take a look at the rdocs for each method for more info):

    <%= simple_form_for @user do |f| %>
      <%= f.label :username %>
      <%= f.input_field :username %>
      <%= f.hint 'No special characters, please!' %>
      <%= f.error :username, :id => 'user_name_error' %>
      <%= f.full_error :token %>
      <%= f.submit 'Save' %>
    <% end %>

Any extra option passed to these methods will be rendered as html option.

### Collections

And what if you want to create a select containing the age from 18 to 60 in your form? You can do it overriding the :collection option:

    <%= simple_form_for @user do |f| %>
      <%= f.input :user %>
      <%= f.input :age, :collection => 18..60 %>
      <%= f.button :submit %>
    <% end %>

Collections can be arrays or ranges, and when a :collection is given the :select input will be rendered by default, so we don't need to pass the :as => :select option. Other types of collection are :radio and :check_boxes. Those are added by SimpleForm to Rails set of form helpers (read Extra Helpers session below for more information).

Collection inputs accepts two other options beside collections:

* label_method => the label method to be applied to the collection to retrieve the label

* value_method => the value method to be applied to the collection to retrieve the value

Those methods are useful to manipulate the given collection. Both of these options also except lambda/procs in case you want to calculate the value or label in a special way eg. custom translation. All other options given are sent straight to the underlying helper. For example, you can give prompt as:

    f.input :age, :collection => 18..60, :prompt => "Select your age"

### Priority

SimpleForm also supports :time_zone and :country. When using such helpers, you can give :priority as option to select which time zones and/or countries should be given higher priority:

    f.input :residence_country, :priority => [ "Brazil" ]
    f.input :time_zone, :priority => /US/

Those values can also be configured with a default value to be used site use through the SimpleForm.country_priority and SimpleForm.time_zone_priority helpers.

### Wrapper

SimpleForm allows you to add a wrapper which contains the label, error, hint and input.
The first step is to configure a wrapper tag:

    SimpleForm.wrapper_tag = :p

And now, you don't need to wrap your f.input calls anymore:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username %>
      <%= f.input :password %>
      <%= f.button :submit %>
    <% end %>
