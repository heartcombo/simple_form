module SimpleForm
  module Oms
    module ActiveRecord

      # An instance of SimpleForm::Column that describes the column
      def simple_form_column_for attribute
        ar_col = columns_hash[attribute.to_s]
        return unless ar_col
        SimpleForm::Column.new do |sf_col|
          sf_col.type = ar_col.type
          sf_col.limit = ar_col.limit
        end
      end

      def simple_form_association_for attribute
        ar_assoc = reflect_on_association attribute
        return unless ar_assoc
        SimpleForm::Association.new do |sf_assoc|
          sf_assoc.klass = ar_assoc.klass
          sf_assoc.macro_method = ar_assoc.macro_method
          sf_assoc.name = ar_assoc.name
          sf_assoc.options = ar_assoc.options
        end
      end

    end
  end
end

ActiveRecord::Base.extend SimpleForm::Oms::ActiveRecord
