require 'ostruct'

Column = Struct.new(:name, :type, :limit)
Association = Struct.new(:klass)

class Company < Struct.new(:id, :name)
  def self.all(options={})
    all = (1..3).map{|i| Company.new(i, "Company #{i}")}
    return [all.first] if options[:conditions]
    return [all.last]  if options[:order]
    all
  end
end

class User < OpenStruct
  attr_reader :id

  def initialize(attributes={})
    @id = attributes.delete(:id)
    super
  end

  def new_record!
    @new_record = true
  end

  def new_record?
    @new_record || false
  end

  def column_for_attribute(attribute)
    column_type, limit = case attribute.to_sym
      when :name, :status, :password then [:string, 100]
      when :description   then :text
      when :age           then :integer
      when :credit_limit  then [:decimal, 15]
      when :active        then :boolean
      when :born_at       then :date
      when :delivery_time then :time
      when :created_at    then :datetime
      when :updated_at    then :timestamp
    end
    Column.new(attribute, column_type, limit)
  end

  def self.human_attribute_name(attribute)
    case attribute
      when 'name' then 'Super User Name!'
      when 'description' then 'User Description!'
      else attribute.humanize
    end
  end

  def self.human_name
    "User"
  end

  def self.reflect_on_association(association)
    Association.new(Company) if association == :company
  end

  def errors
    @errors ||= {
      :name => "can't be blank",
      :description => "must be longer than 15 characters",
      :age => ["is not a number", "must be greater than 18"],
    }
  end
end
