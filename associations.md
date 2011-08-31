---
layout: default
---

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

Simple enough right? This is going to render a :select input for choosing the :company, and another :select input with :multiple option for the :roles. You can of course change it, to use radios and check boxes as well:

    f.association :company, :as => :radio
    f.association :roles,   :as => :check_boxes

The association helper just invokes input under the hood, so all options available to :select, :radio and :check_boxes are also available to association. Additionally, you can specify the collection by hand, all together with the prompt:

    f.association :company, :collection => Company.active.all(:order => 'name'), :prompt => "Choose a Company"
