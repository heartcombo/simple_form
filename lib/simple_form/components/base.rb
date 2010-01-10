module SimpleForm
  module Components
    # The component is the core of SimpleForm. SimpleForm can be customized simply
    # with the addition of new components to the component stack. A component just
    # need to be initialized with two values, the builder and the next component to
    # be invoked and respond to call.
    #
    # The Base component is a raw component with some helpers and a default behavior
    # of prepending the content available in the method content.
    class Base
      delegate :template, :object, :object_name, :attribute_name, :column,
               :reflection, :input_type, :options, :to => :@builder

      # When action is create or update, we still should use new and edit
      ACTIONS = {
        :create => :new,
        :update => :edit
      }

      def self.basename
        @basename ||= name.split("::").last.underscore.to_sym
      end

      def initialize(builder, component)
        @builder    = builder
        @component  = component
      end

      # Generate component content and call next component in the stack. When a
      # component is invalid it will be skipped.
      def call
        return @component.call unless valid?
        content + @component.call
      end

      def valid?
        true
      end

      def hidden_input?
        input_type == :hidden
      end

      def basename
        self.class.basename
      end

      # Find reflection name when available, otherwise use attribute
      def reflection_or_attribute_name
        reflection ? reflection.name : attribute_name
      end

      # Default html options for a component. Passed as a parameter for simple
      # form component using component name as follows:
      #
      #   label_html => {}
      #   input_html => {}
      #   hint_html => {}
      #   error_html => {}
      #   wrapper_html => {}
      #
      def component_html_options
        options[:"#{basename}_html"] || {}
      end

      # Renders default content tag for components, using default html class
      # and user defined parameters.
      # Default component tag can be configured in SimpleForm.component_tag.
      def component_tag(content)
        html_options = component_html_options
        html_options[:class] = "#{basename} #{html_options[:class]}".strip
        template.content_tag(SimpleForm.component_tag, content, html_options)
      end

      # Lookup translations for components using I18n, based on object name,
      # actual action and attribute name. Lookup priority as follows:
      #
      #   simple_form.{type}.{model}.{action}.{attribute}
      #   simple_form.{type}.{model}.{attribute}
      #   simple_form.{type}.{attribute}
      #
      #  Type is used for :labels and :hints.
      #  Model is the actual object name, for a @user object you'll have :user.
      #  Action is the action being rendered, usually :new or :edit.
      #  And attribute is the attribute itself, :name for example.
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
      def translate(default='')
        lookups = []
        lookups << :"#{object_name}.#{lookup_action}.#{reflection_or_attribute_name}"
        lookups << :"#{object_name}.#{reflection_or_attribute_name}"
        lookups << :"#{reflection_or_attribute_name}"
        lookups << default
        I18n.t(lookups.shift, :scope => :"simple_form.#{basename.to_s.pluralize}", :default => lookups)
      end

      # The action to be used in lookup.
      def lookup_action
        action = template.controller.action_name.to_sym
        ACTIONS[action] || action
      end
    end
  end
end
