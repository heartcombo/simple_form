require 'simple_form/abstract_component'
require 'simple_form/i18n_cache'

require 'simple_form/label'
require 'simple_form/input'
require 'simple_form/hint'
require 'simple_form/error'
require 'simple_form/map_type'


module SimpleForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    # Make the template accessible for components
    attr_reader :template

    include SimpleForm::Input

    extend SimpleForm::MapType
    extend SimpleForm::I18nCache

    map_type :boolean,  :to => :check_box
    map_type :text,     :to => :text_area
    map_type :datetime, :to => :datetime_select, :options => true
    map_type :date,     :to => :date_select, :options => true
    map_type :time,     :to => :time_select, :options => true
    map_type :password, :to => :password_field
    map_type :hidden,   :to => :hidden_field
    map_type :select,   :to => :collection_select, :options => true, :collection => true
    map_type :radio,    :to => :collection_radio, :collection => true
    map_type :numeric,  :to => :text_field
    map_type :string,   :to => :text_field

    def input(attribute, options={})
      @attribute, @options = attribute, options
      @options.assert_valid_keys(:as, :label, :required, :hint, :options, :html,
                                 :collection, :label_method, :value_method)

      @input_type = (@options[:as] || default_input_type).to_sym

      label  = Label.new(self, @attribute, @input_type, @options).generate unless @options[:label] == false
      input = generate_input
      hint  = Hint.new(self, @attribute, @input_type, @options).generate unless @options[:hint] == false
      error = Error.new(self, @attribute, @input_type, @options).generate

      label.to_s << input << hint.to_s << error
    end

    private

      def default_input_type
        column = @object.column_for_attribute(@attribute)
        input_type = column.type
        case input_type
          when :decimal, :integer then :numeric
          when :timestamp then :datetime
          when nil, :string then
            @attribute.to_s =~ /password/ ? :password : :string
          else input_type
        end
      end

      def hidden_input?
        @input_type == :hidden
      end

      def translate_form(scope, default='')
        lookups = [:"#{@object_name}.#{@attribute}", :"#{@attribute}", default]
        I18n.t(lookups.shift, :scope => :"simple_form.#{scope}", :default => lookups)
      end

  end
end
