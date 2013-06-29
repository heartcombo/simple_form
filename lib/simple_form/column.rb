# A Column object respresents the specs of an attribute as defined in
# the database in an Object Mapper independent manor. A Object Mapper
# independent version of ActiveRecord::ConnectionAdapters::ColumnDefinition
class SimpleForm::Column

  # The type of data stored in this column. This is a symbol.
  attr_accessor :type

  # The maximum size of data stored in this column. validates_length_of
  # may further refine this amount but this is just what the database
  # is capable of storing.
  attr_accessor :limit

  # Creates a new column. Takes a block to assign the attributes.
  def initialize
    yield self if block_given?
  end

  # Is the type some sort of number
  def number?
    %w(integer float decimal).include? type.to_s
  end

end
