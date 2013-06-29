module SimpleForm
  # The general strategy is to let ActiveModel provide compatability
  # between different object mappers. But there are a few additional
  # abstractions that are needed. These additional abstractions are
  # all prefixed with simple_form_ to reduce our pollution of the
  # object mapper's namespace.
  module Oms

    # ActiveRecord extensions to complete the object mapper abstraction.
    #
    # ActiveRecord is the gold standard of object mappers. When adding
    # support for additional object mappers you MUST implement every
    # method in this module.
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

      # An instance of SimpleForm::Association that describe the
      # relationship between two objects.
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

      # Proxy to real method. Just to provide common interface
      def simple_form_readonly_attributes
        readonly_attributes
      end

    end
  end
end

ActiveRecord::Base.extend SimpleForm::Oms::ActiveRecord
