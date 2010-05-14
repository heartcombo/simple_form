module SimpleForm
  module Inputs
    class Base
      extend I18nCache

      # When action is create or update, we still should use new and edit
      ACTIONS = {
        :create => :new,
        :update => :edit
      }

      include SimpleForm::Components::Errors
      include SimpleForm::Components::Hints
      include SimpleForm::Components::Labels
      include SimpleForm::Components::Wrapper

      delegate :template, :object, :object_name, :attribute_name, :column,
               :reflection, :input_type, :options, :to => :@builder

      def initialize(builder)
        @builder = builder
      end

      def input
        raise NotImplementedError
      end

      def input_options
        options
      end

      def input_html_options
        html_options_for(:input, input_type, required_class)
      end

      def render
        content = components_list.map do |component|
          next if options[component] == false
          send(component)
        end
        content.compact!
        wrap(content.join.html_safe)
      end

    protected

      def components_list
        SimpleForm.components
      end

      def attribute_required?
        klass = object.class
        if defined? klass.validators_on
          return options[:required] unless options[:required].nil?
          return klass.validators_on(attribute_name).map {|validator| validator.kind}.include?(:presence)
        end
        options[:required] != false
      end

      def required_class
        attribute_required? ? :required : :optional
      end

      # Find reflection name when available, otherwise use attribute
      def reflection_or_attribute_name
        reflection ? reflection.name : attribute_name
      end

      # Retrieve options for the given namespace from the options hash
      def html_options_for(namespace, *extra)
        html_options = options[:"#{namespace}_html"] || {}
        html_options[:class] = (extra << html_options[:class]).join(' ').strip if extra.present?
        html_options
      end

      # Lookup translations for the given namespace using I18n, based on object name,
      # actual action and attribute name. Lookup priority as follows:
      #
      #   simple_form.{namespace}.{model}.{action}.{attribute}
      #   simple_form.{namespace}.{model}.{attribute}
      #   simple_form.{namespace}.{attribute}
      #
      #  Namespace is used for :labels and :hints.
      #
      #  Model is the actual object name, for a @user object you'll have :user.
      #  Action is the action being rendered, usually :new or :edit.
      #  And attribute is the attribute itself, :name for example.
      #
      #  Example:
      #
      #    simple_form:
      #      labels:
      #        user:
      #          new:
      #            email: 'E-mail para efetuar o sign in.'
      #          edit:
      #            email: 'E-mail.'
      #
      #  Take a look at our locale example file.
      def translate(namespace, default='')
        lookups = []
        lookups << :"#{object_name}.#{lookup_action}.#{reflection_or_attribute_name}"
        lookups << :"#{object_name}.#{reflection_or_attribute_name}"
        lookups << :"#{reflection_or_attribute_name}"
        lookups << default
        I18n.t(lookups.shift, :scope => :"simple_form.#{namespace}", :default => lookups)
      end

      # The action to be used in lookup.
      def lookup_action
        action = template.controller.action_name.to_sym
        ACTIONS[action] || action
      end
    end
  end
end