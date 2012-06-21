Association = Struct.new(:klass, :name, :macro, :options)

class Column < Struct.new(:name, :type, :limit)
  # Returns +true+ if the column is either of type integer, float or decimal.
  def number?
    type == :integer || type == :float || type == :decimal
  end
end

class Company < Struct.new(:id, :name)
  extend ActiveModel::Naming
  include ActiveModel::Conversion

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
  def self.all(options={})
    (1..3).map{|i| Tag.new(i, "Tag #{i}")}
  end
end

class TagGroup < Struct.new(:id, :name, :tags)
end

class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :name, :company, :company_id, :time_zone, :active, :age,
    :description, :created_at, :updated_at, :credit_limit, :password, :url,
    :delivery_time, :born_at, :special_company_id, :country, :tags, :tag_ids,
    :avatar, :home_picture, :email, :status, :residence_country, :phone_number,
    :post_count, :lock_version, :amount, :attempts, :action, :credit_card, :gender

  def initialize(options={})
    @new_record = false
    options.each do |key, value|
      send("#{key}=", value)
    end if options
  end

  def new_record!
    @new_record = true
  end

  def persisted?
    !@new_record
  end

  def company_attributes=(*)
  end

  def tags_attributes=(*)
  end

  def column_for_attribute(attribute)
    column_type, limit = case attribute.to_sym
      when :name, :status, :password then [:string, 100]
      when :description   then [:text, 200]
      when :age           then :integer
      when :credit_limit  then [:decimal, 15]
      when :active        then :boolean
      when :born_at       then :date
      when :delivery_time then :time
      when :created_at    then :datetime
      when :updated_at    then :timestamp
      when :lock_version  then :integer
      when :home_picture  then :string
      when :amount        then :integer
      when :attempts      then :integer
      when :action        then :string
      when :credit_card   then :string
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
    @errors ||= begin
      hash = Hash.new { |h,k| h[k] = [] }
      hash.merge!(
        :name => ["can't be blank"],
        :description => ["must be longer than 15 characters"],
        :age => ["is not a number", "must be greater than 18"],
        :company => ["company must be present"],
        :company_id => ["must be valid"]
      )
    end
  end

  def self.readonly_attributes
    ["credit_card"]
  end
end

class ValidatingUser < User
  include ActiveModel::Validations
  validates :name, :presence => true
  validates :company, :presence => true
  validates :age, :presence => true, :if => Proc.new { |user| user.name }
  validates :amount, :presence => true, :unless => Proc.new { |user| user.age }

  validates :action,            :presence => true, :on => :create
  validates :credit_limit,      :presence => true, :on => :save
  validates :phone_number,      :presence => true, :on => :update

  validates_numericality_of :age,
    :greater_than_or_equal_to => 18,
    :less_than_or_equal_to => 99,
    :only_integer => true
  validates_numericality_of :amount,
    :greater_than => :min_amount,
    :less_than => :max_amount,
    :only_integer => true
  validates_numericality_of :attempts,
    :greater_than_or_equal_to => :min_attempts,
    :less_than_or_equal_to => :max_attempts,
    :only_integer => true
  validates_length_of :name, :maximum => 25
  validates_length_of :description, :maximum => 50
  validates_length_of :action, :maximum => 10, :tokenizer => lambda { |str| str.scan(/\w+/) }
  validates_length_of :home_picture, :is => 12

  def min_amount
    10
  end

  def max_amount
    100
  end

  def min_attempts
    1
  end

  def max_attempts
    100
  end
end

class OtherValidatingUser < User
  include ActiveModel::Validations
  validates_numericality_of :age,
    :greater_than => 17,
    :less_than => 100,
    :only_integer => true
  validates_numericality_of :amount,
    :greater_than => Proc.new { |user| user.age },
    :less_than => Proc.new { |user| user.age + 100},
    :only_integer => true
  validates_numericality_of :attempts,
    :greater_than_or_equal_to => Proc.new { |user| user.age },
    :less_than_or_equal_to => Proc.new { |user| user.age + 100},
    :only_integer => true

  validates_format_of :country, :with => /\w+/

  # TODO: Remove this check when we drop Rails 3.0 support
  if ActiveModel::VERSION::MAJOR == 3 && ActiveModel::VERSION::MINOR >= 1
    validates_format_of :name, :with => Proc.new { /\w+/ }
  else
    validates_format_of :name, :with => /\w+/
  end
end

class HashBackedAuthor < Hash
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?; false; end

  def name
    'hash backed author'
  end
end
