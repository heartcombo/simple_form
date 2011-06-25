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
      include SimpleForm::Components::LabelInput
      include SimpleForm::Components::Placeholders
      include SimpleForm::Components::Wrapper

      attr_reader :attribute_name, :column, :input_type, :reflection,
                  :options, :input_html_options

      delegate :template, :object, :object_name, :to => :@builder

      def initialize(builder, attribute_name, column, input_type, options = {})
        @builder            = builder
        @attribute_name     = attribute_name
        @column             = column
        @input_type         = input_type
        @reflection         = options.delete(:reflection)
        @options            = options
        @input_html_options = html_options_for(:input, input_html_classes).tap do |o|
          o[:required]  = true if has_required? # Don't make this conditional on HTML5 here, because we want the CSS class to be set
          o[:disabled]  = true if disabled?
          o[:autofocus] = true if has_autofocus? && SimpleForm.html5
        end
      end

      def input
        raise NotImplementedError
      end

      def input_options
        options
      end

      def input_html_classes
        [input_type, required_class, protected_class].compact
      end

      def render
        content = "".html_safe
        components_list.each do |component|
          next if options[component] == false
          rendered = send(component)
          content.safe_concat rendered.to_s if rendered
        end
        wrap(content)
      end

    protected
    
      def components_list
        options[:components] || SimpleForm.components
      end

      def attribute_required?
        if !options[:required].nil?
          options[:required]
        elsif has_validators?
          (attribute_validators + reflection_validators).any? do |v|
            v.kind == :presence && !conditional_validators?(v)
          end
        else
          attribute_required_by_default?
        end
      end

      # Whether this input is valid for HTML 5 required attribute.
      def has_required?
        attribute_required? && SimpleForm.html5 && SimpleForm.browser_validations
      end

      def has_autofocus?
        options[:autofocus]
      end

      def has_validators?
        attribute_name && object.class.respond_to?(:validators_on)
      end

      def attribute_validators
        object.class.validators_on(attribute_name)
      end

      def reflection_validators
        reflection ? object.class.validators_on(reflection.name) : []
      end

      def conditional_validators?(validator)
        validator.options.include?(:if) || validator.options.include?(:unless)
      end

      def attribute_required_by_default?
        SimpleForm.required_by_default
      end

      def required_class
        attribute_required? ? :required : :optional
      end

      # Find reflection name when available, otherwise use attribute
      def reflection_or_attribute_name
        reflection ? reflection.name : attribute_name
      end

      # Retrieve options for the given namespace from the options hash
      def html_options_for(namespace, extra)
        html_options = options[:"#{namespace}_html"] || {}
        html_options[:class] = (extra << html_options[:class]).join(' ').strip if extra.present?
        html_options
      end
      
      def class_active_authorizer
        return nil unless object.class.respond_to?(:active_authorizer)
        authorizer = object.class.active_authorizer
        
        # Rails 3.1 support
        # active_authorizer returns a hash where key is :role, use :default
        if authorizer.is_a?(Hash) && authorizer.has_key?(:default)
          authorizer = authorizer[:default]
        end
        authorizer
      end
      
      def class_uses_whitelist?
        class_active_authorizer.is_a?(ActiveModel::MassAssignmentSecurity::WhiteList)
      end

      def class_uses_blacklist?
        class_active_authorizer.is_a?(ActiveModel::MassAssignmentSecurity::BlackList)
      end

      def attribute_whitelisted?
        class_uses_whitelist? &&
          class_active_authorizer.include?(attribute_name.to_s)
      end

      def attribute_blacklisted?
        class_uses_blacklist? &&
          class_active_authorizer.include?(attribute_name.to_s)
      end

      def attribute_protected?
        return false unless SimpleForm.use_protected
        # whitelist (attr_accessible), if used it has priority (like in Rails)
        class_uses_whitelist? ? !attribute_whitelisted? : attribute_blacklisted?
      end

      def protected_class
        attribute_protected? ? SimpleForm.protected_class : nil
      end

      def protected_and_disabled?
        SimpleForm.disable_when_protected && attribute_protected?
      end

      def disabled?
        options[:disabled] || protected_and_disabled?
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
      #  The lookup for nested attributes is also done in a nested format using
      #  both model and nested object names, such as follow:
      #
      #   simple_form.{namespace}.{model}.{nested}.{action}.{attribute}
      #   simple_form.{namespace}.{model}.{nested}.{attribute}
      #   simple_form.{namespace}.{nested}.{action}.{attribute}
      #   simple_form.{namespace}.{nested}.{attribute}
      #   simple_form.{namespace}.{attribute}
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
        return nil unless SimpleForm.translate

        model_names = lookup_model_names
        lookups     = []

        while !model_names.empty?
          joined_model_names = model_names.join(".")
          model_names.shift

          lookups << :"#{joined_model_names}.#{lookup_action}.#{reflection_or_attribute_name}"
          lookups << :"#{joined_model_names}.#{reflection_or_attribute_name}"
        end
        lookups << :"#{reflection_or_attribute_name}"
        lookups << default

        I18n.t(lookups.shift, :scope => :"simple_form.#{namespace}", :default => lookups).presence
      end

      # Extract the model names from the object_name mess, ignoring numeric and
      # explicit child indexes.
      #
      # Example:
      #
      # route[blocks_attributes][0][blocks_learning_object_attributes][1][foo_attributes]
      # ["route", "blocks", "blocks_learning_object", "foo"]
      #
      def lookup_model_names
        child_index = @builder.options[:child_index]
        names = object_name.to_s.scan(/([a-zA-Z_]+)/).flatten
        names.delete(child_index) if child_index
        names.each { |name| name.gsub!('_attributes', '') }
      end

      # The action to be used in lookup.
      def lookup_action
        action = template.controller.action_name
        return unless action
        action = action.to_sym
        ACTIONS[action] || action
      end

      def input_method
        self.class.mappings[input_type] or
          raise("Could not find method for #{input_type.inspect}")
      end
    end
  end
end
