require 'ostruct'

class Column
  attr_accessor :name, :type#, :limit, :precision, :scale

  def initialize(attrs={})
    self.name = attrs[:name]
    self.type = attrs[:type]
  end
end

class User < OpenStruct

  def id
    1
  end

  def new_record?
    false
  end

  def column_for_attribute(attribute)
    column_type = case attribute.to_sym
      when :name, :status, :password then :string
      when :description   then :text
      when :age           then :integer
      when :credit_limit  then :decimal
      when :active        then :boolean
      when :born_at       then :date
      when :delivery_time then :time
      when :created_at    then :datetime
      when :updated_at    then :timestamp
    end
    Column.new(:name => attribute, :type => column_type)
  end

  def human_attribute_name(attribute)
    nil
  end

  def errors
    {}
  end
end

class SuperUser < User

  def human_attribute_name(attribute)
    case attribute
      when 'name' then 'Super User Name!'
      else super
    end
  end

  def errors
    @errors ||= {
      :name => "can't be blank",
      :description => "must be longer than 15 characters",
      :age => ["is not a number", "must be greater than 18"],
      :credit_limit => ["must be present", "must be greater than 0"]
    }
  end
end
