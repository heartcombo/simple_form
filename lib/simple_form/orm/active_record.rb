module SimpleForm
  module Orm
    module ActiveRecord
      def find_attribute_column_by_reflection(reflection, options)
        case reflection.macro
        when :belongs_to
          reflection.options[:foreign_key] || :"#{reflection.name}_id"
        when :has_one
          raise ":has_one association are not supported by f.association"
        else
          if options[:as] == :select
            html_options = options[:input_html] ||= {}
            html_options[:size]   ||= 5
            html_options[:multiple] = true unless html_options.key?(:multiple)
          end

          :"#{reflection.name.to_s.singularize}_ids"
        end
      end
    end
  end
end

SimpleForm::FormBuilder.send :include, SimpleForm::Orm::ActiveRecord
