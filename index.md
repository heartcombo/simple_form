---
layout: default
---

## SimpleForm

Forms made easy (for Rails)!

SimpleForm aims to be as flexible as possible while helping you with powerful components to create your forms. The basic goal of simple form is to not touch your way of defining the layout, letting you find the better design for your eyes. Good part of the DSL was inherited from Formtastic, which we are thankful for and should make you feel right at home.

## Information

### Google Group

If you have any questions, comments, or concerns please use the Google Group instead of the GitHub Issues tracker:

<http://groups.google.com/group/plataformatec-simpleform>

### RDocs

You can view the SimpleForm documentation in RDoc format here:

<http://rubydoc.info/github/plataformatec/simple_form/master/frames>

If you need to use SimpleForm with Rails 2.3, you can always run `gem server` from the command line after you install the gem to access the old documentation.

### Bug reports

If you discover any bugs, feel free to create an issue on GitHub. Please add as much information as possible to help us fixing the possible bug. We also encourage you to help even more by forking and sending us a pull request.

<http://github.com/plataformatec/simple_form/issues>

## Installation

Install the gem:

    gem install simple_form

Add it to your Gemfile:

    gem "simple_form"

Run the generator:

    rails generate simple_form:install

Also, if you want to use the country select, you will need the country_select plugin, install with following command:

    rails plugin install git://github.com/rails/country_select.git

And you are ready to go. Since this branch aims Rails 3 support,
if you want to use it with Rails 2.3 you should check this branch:

<http://github.com/plataformatec/simple_form/tree/v1.0>

## Basic usage

SimpleForm was designed to be customized as you need to. Basically it's a stack of components that are invoked to create a complete html input for you, which by default contains label, hints, errors and the input itself. It does not aim to create a lot of different logic from the default Rails form helpers, as they do a great work by themselves. Instead, SimpleForm acts as a DSL and just maps your input type (retrieved from the column definition in the database) to an specific helper method.

To start using SimpleForm you just have to use the helper it provides:

    <%= simple_form_for @user do |f| %>
      <%= f.input :username %>
      <%= f.input :password %>
      <%= f.button :submit %>
    <% end %>

[More](/usage.html)

## Associations

To deal with associations, SimpleForm can generate select inputs, a series of radios or check boxes. Lets see how it works: imagine you have a user model that belongs to a company and has_and_belongs_to_many roles. The structure would be something like:

    class User < ActiveRecord::Base
      belongs_to :company
      has_and_belongs_to_many :roles
    end

    class Company < ActiveRecord::Base
      has_many :users
    end

    class Role < ActiveRecord::Base
      has_and_belongs_to_many :users
    end

Now we have the user form:

    <%= simple_form_for @user do |f| %>
      <%= f.input :name %>
      <%= f.association :company %>
      <%= f.association :roles %>
      <%= f.button :submit %>
    <% end %>

[More](/associations.html)

## Mappings/Inputs available

SimpleForm comes with a lot of default mappings:

<pre>
  Mapping               Input                   Column Type

  boolean               check box               boolean
  string                text field              string
  email                 email field             string with name matching "email"
  url                   url field               string with name matching "url"
  tel                   tel field               string with name matching "phone"
  password              password field          string with name matching "password"
  search                search                  -
  text                  text area               text
  file                  file field              string, responding to file methods
  hidden                hidden field            -
  integer               number field            integer
  float                 number field            float
  decimal               number field            decimal
  datetime              datetime select         datetime/timestamp
  date                  date select             date
  time                  time select             time
  select                collection select       belongs_to/has_many/has_and_belongs_to_many associations
  radio                 collection radio        belongs_to
  check_boxes           collection check box    has_many/has_and_belongs_to_many associations
  country               country select          string with name matching "country"
  time_zone             time zone select        string with name matching "time_zone"
</pre>

## I18n

SimpleForm uses all power of I18n API to lookup labels, hints and placeholders. To customize your forms you can create a locale file like this:

    en:
      simple_form:
        labels:
          user:
            username: 'User name'
            password: 'Password'
        hints:
          user:
            username: 'User name to sign in.'
            password: 'No special characters, please.'
        placeholders:
          user:
            username: 'Your username'
            password: '****'

And your forms will use this information to render the components for you.

[More](/i18n.html)

## HTML 5 Notice

By default, SimpleForm will generate input field types and attributes that are supported in HTML5, but are considered invalid HTML for older document types such as HTML4 or XHTML1.0. The HTML5 extensions include the new field types such as email, number, search, url, tel, and the new attributes such as required, autofocus, maxlength, min, max, step.

[More](/html5.html)

## Maintainers

* José Valim (https://github.com/josevalim)
* Carlos Antonio da Silva (https://github.com/carlosantoniodasilva)
* Rafael Mendonça França (https://github.com/rafaelfranca)

## License

MIT License. Copyright 2011 [Plataforma Tecnologia](http://blog.plataformatec.com.br).
