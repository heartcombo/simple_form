require 'ostruct'

Column = Struct.new(:name, :type, :limit)
Association = Struct.new(:klass, :name, :macro, :options)

class Company < Struct.new(:id, :name)
  extend ActiveModel::Naming

  def self.all(options={})
    all = (1..3).map{|i| Company.new(i, "Company #{i}")}
    return [all.first] if options[:conditions].present?
    return [all.last]  if options[:order].present?
    return all[0..1] if options[:include].present?
    return all[1..2] if options[:joins].present?
    all
  end

  def self.merge_conditions(a, b)
    (a || {}).merge(b || {})
  end

  def persisted?
    true
  end
end

class Tag < Company
  extend ActiveModel::Naming

  def self.all(options={})
    (1..3).map{|i| Tag.new(i, "Tag #{i}")}
  end
end

class User < OpenStruct
  extend ActiveModel::Naming

  # Get rid of deprecation warnings
  undef_method :id

  def new_record!
    @new_record = true
  end

  def persisted?
    !(@new_record || false)
  end

  def company_attributes=(*)
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
      when 'name'
        'Super User Name!'
      when 'description'
        'User Description!'
      when 'company'
        'Company Human Name!'
      else
        attribute.humanize
    end
  end

  def self.reflect_on_association(association)
    case association
      when :company
        Association.new(Company, association, :belongs_to, {})
      when :tags
        Association.new(Tag, association, :has_many, {})
      when :first_company
        Association.new(Company, association, :has_one, {})
      when :special_company
        Association.new(Company, association, :belongs_to, { :conditions => { :id => 1 } })
    end
  end

  def errors
    @errors ||= {
      :name => "can't be blank",
      :description => "must be longer than 15 characters",
      :age => ["is not a number", "must be greater than 18"],
      :company => "company must be present",
      :company_id => "must be valid"
    }
  end
end

class ValidatingUser < User
  include ActiveModel::Validations
  validates :name, :presence => true
end
