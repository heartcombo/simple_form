module SimpleForm
  module Oms
    module MongoMapper
      extend ActiveSupport::Concern

      module ClassMethods
        # Returns a SimpleForm::Column that describes the attribute 
        def simple_form_column_for attribute
          mm_col = keys[attribute.to_s]
          return unless mm_col
          SimpleForm::Column.new do |sf_col|
            sf_col.type = mm_col.type.name.underscore.to_sym
            sf_col.limit = nil # Mongo doesn't have limits :)
          end
        end

        # Returns a SimpleForm::Association that describes the relationship
        def simple_form_association_for attribute
          mm_assoc = associations[attribute]
          return unless mm_assoc
          SimpleForm::Association.new do |sf_assoc|
            sf_assoc.klass = mm_assoc.klass
            sf_assoc.name = mm_assoc.name
            sf_assoc.macro = case mm_assoc.class.name
              when /BelongsTo/ then :belongs_to
              when /One/ then :has_one
              when /Many/ then :has_many
            end
            sf_assoc.options = mm_assoc.options
          end
        end

        # MongoMapper doesn't support readonly attributes
        def readonly_attributes; [] end
      end

    end
  end
end

MongoMapper::Document.plugin SimpleForm::Oms::MongoMapper
MongoMapper::EmbeddedDocument.plugin SimpleForm::Oms::MongoMapper
