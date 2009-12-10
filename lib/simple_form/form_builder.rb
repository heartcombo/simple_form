module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    attr_reader :template, :object_name, :object, :attribute, :column,
                :input_type, :options

    # Creates a input with all components.
    def input(attribute, options={})
      @attribute, @options = attribute, options
      @column = find_attribute_column
      @input_type = default_input_type

      component = SimpleForm.terminator
      SimpleForm.components.reverse.each do |klass|
        next if @options[klass.basename] == false
        component = klass.new(self, component)
      end
      component.call
    end

    # Creates a button:
    #
    #   form_for @user do |f|
    #     f.button :submit
    #   end
    #
    # If the record is a new_record?, it will create a button with label "Create User",
    # otherwise it will create with label "Update User". You can overwrite the label
    # giving a second parameter or giving :label.
    #
    #   f.button :submit, "Create a new user"
    #   f.button :submit, :label => "Create a new user"
    #
    # button is actually just a wrapper that adds a default text, that said, f.button
    # above is just calling:
    #
    #   submit_tag "Create a new user"
    #
    # All options given to button are given straight to submit_tag. That said, you can
    # use :confirm normally:
    #
    #   f.button :submit, :confirm => "Are you sure?"
    #
    # And if you want to use image_submit_tag, just give it as an option:
    #
    #   f.button :image_submit, "/images/foo/bar.png"
    #
    # This comes with a bonus that any method added to your ApplicationController can
    # be used by SimpleForm, as long as it ends with _tag. So is quite easy to customize
    # your buttons.
    #
    def button(type, *args)
      options = args.extract_options!
      value   = args.first || options.delete(:label)

      value ||= begin
        if @object
          key   = @object.new_record? ? :create : :update
          model = @object.class.human_name if @object.class.respond_to?(:human_name)
        end

        key   ||= :submit
        model ||= @object_name.to_s.humanize

        I18n.t(:"simple_form.#{key}", :model => model, :default => "#{key.to_s.humanize} #{model}")
      end

      @template.send(:"#{type}_tag", value, options)
    end

  private

    def default_input_type
      return @options[:as].to_sym if @options[:as]
      return :select              if @options[:collection]

      input_type = column.try(:type)

      case input_type
        when :timestamp
          :datetime
        when :string, nil
          @attribute.to_s =~ /password/ ? :password : :string
        else
          input_type
      end
    end

    def find_attribute_column
      @object.column_for_attribute(@attribute) if @object.respond_to?(:column_for_attribute)
    end

  end
end
