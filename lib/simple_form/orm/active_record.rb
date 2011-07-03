module SimpleForm
  module Orm
    module ActiveRecord
      def find_attribute_column_by_reflection reflection
        case reflection.macro
        when :belongs_to
          reflection.options[:foreign_key] || :"#{reflection.name}_id"
        when :has_one
          raise ":has_one associations are not supported by f.association"
        else
          :"#{reflection.name.to_s.singularize}_ids"
        end
      end
    end
  end
end

SimpleForm::FormBuilder.send :include, SimpleForm::Orm::ActiveRecord
