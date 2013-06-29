# An Association object represents the specs of an relationship as
# defined by the Object Mapper in an Object Mapper independent mannor.
# A Object Mapper independent version of
# ActiveRecord::Associations::Association
class SimpleForm::Association

  # Should be :belongs_to, :has_one or :has_many
  attr_accessor :macro

  # The type of object this association relates to
  attr_accessor :klass

  # The name of this association
  attr_accessor :name

  # Configuration options for the assocation. The options that SimpleForm
  # actually uses are. :foreign_key, :conditions and :order. They are
  # all optional.
  attr_reader :options

  # Creates a new assocation. Takes a block to assign the attributes
  def initialize
    @options = {}
    yield self if block_given?
  end

end
