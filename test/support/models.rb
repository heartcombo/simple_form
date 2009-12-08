require 'ostruct'

class User < OpenStruct

  def id
    1
  end

  def new_record?
    false
  end

  def column_for_attribute(attribute)
    case attribute.to_sym
      when :name, :status then :string
      when :description   then :text
      when :age           then :integer
      when :credit_limit  then :decimal
      when :active        then :boolean
      when :born_at       then :date
      when :delivery_time then :time
      when :created_at    then :datetime
      when :updated_at    then :timestamp
    end
  end

  def human_attribute_name(attribute)
    nil
  end
end

class SuperUser < User

  def human_attribute_name(attribute)
    case attribute
      when 'name' then 'Super User Name!'
      else super
    end
  end
end
