module SimpleForm
  module Orm
    module Mongoid
      def find_attribute_column_by_reflection reflection
        case reflection.relation.macro
        when :embedded_in, :embeds_one
          :"#{reflection.name.to_s.singularize}"
        when :referenced_in, :references_one
          :"#{reflection.name.to_s.singularize}_id"
        when :embeds_many
          :"#{reflection.name.to_s.pluralize}"
        else
          :"#{reflection.name.to_s.singularize}_ids"
        end
      end
    end
  end
end

SimpleForm::FormBuilder.send :include, SimpleForm::Orm::Mongoid
