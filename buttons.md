---
layout: default
---

## Buttons

All web forms need buttons, right? SimpleForm wraps them in the DSL, acting like a proxy:

    <%= simple_form_for @user do |f| %>
      <%= f.input :name %>
      <%= f.button :submit %>
    <% end %>

The above will simply call submit. You choose to use it or not, it's just a question of taste.
