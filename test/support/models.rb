Relation = Struct.new(:all) do
  def where(conditions = nil)
    self.class.new conditions ? all.first : all
  end

  def order(conditions = nil)
    self.class.new conditions ? all.last : all
  end

  alias_method :to_a, :all
end

Company = Struct.new(:id, :name) do
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  class << self
    delegate :order, :where, to: :_relation
  end

  def self._relation
    Relation.new(all)
  end

  def self.all
    (1..3).map { |i| new(i, "#{name} #{i}") }
  end

  def persisted?
    true
  end
end

class Tag < Company; end

TagGroup = Struct.new(:id, :name, :tags)

class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :name, :company, :company_id, :time_zone, :active, :age,
    :description, :created_at, :updated_at, :credit_limit, :password, :url,
    :delivery_time, :born_at, :special_company_id, :country, :tags, :tag_ids,
    :avatar, :home_picture, :email, :status, :residence_country, :phone_number,
    :post_count, :lock_version, :amount, :attempts, :action, :credit_card, :gender,
    :extra_special_company_id

  def self.build(extra_attributes = {})
    attributes = {
      id: 1,
      name: 'New in SimpleForm!',
      description: 'Hello!',
      created_at: Time.now
    }.merge! extra_attributes

    new attributes
  end

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

  def self.simple_form_column_for attribute
    type, limit = {
      :name           => [:string, 100],
      :status         => [:string, 100],
      :password       => [:string, 100],
      :description    => [:text, 200],
      :age            => :integer,
      :credit_limit   => [:decimal, 15],
      :active         => :boolean,
      :born_at        => :date,
      :delivery_time  => :time,
      :created_at     => :datetime,
      :updated_at     => :timestamp,
      :lock_version   => :integer,
      :home_picture   => :string,
      :amount         => :integer,
      :attempts       => :integer,
      :action         => :string,
      :credit_card    => :string,
    }[attribute]
    SimpleForm::Column.new do |col|
      col.type = type
      col.limit = limit
    end
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

  def self.simple_form_association_for association
    case association
      when :company
        SimpleForm::Association.new do |assoc|
          assoc.klass = Company
          assoc.name = :company
          assoc.macro = :belongs_to
        end
      when :tags
        SimpleForm::Association.new do |assoc|
          assoc.klass = Tag
          assoc.name = :tags
          assoc.macro = :has_many
        end
      when :first_company
        SimpleForm::Association.new do |assoc|
          assoc.klass = Company
          assoc.name = :first_company
          assoc.macro = :has_one
        end
      when :special_company
        SimpleForm::Association.new do |assoc|
          assoc.klass = Company
          assoc.name = :special_company
          assoc.macro = :belongs_to
          assoc.options[:conditions] = {id: 1}
        end
      when :extra_special_company
        SimpleForm::Association.new do |assoc|
          assoc.klass = Company
          assoc.name = :extra_special_company
          assoc.macro = :belongs_to
          assoc.options[:conditions] = proc { {id: 1} }
        end
    end
  end

  def errors
    @errors ||= begin
      hash = Hash.new { |h,k| h[k] = [] }
      hash.merge!(
        name: ["can't be blank"],
        description: ["must be longer than 15 characters"],
        age: ["is not a number", "must be greater than 18"],
        company: ["company must be present"],
        company_id: ["must be valid"]
      )
    end
  end

  def self.readonly_attributes
    ["credit_card"]
  end
end

class ValidatingUser < User
  include ActiveModel::Validations
  validates :name, presence: true
  validates :company, presence: true
  validates :age, presence: true, if: Proc.new { |user| user.name }
  validates :amount, presence: true, unless: Proc.new { |user| user.age }

  validates :action,            presence: true, on: :create
  validates :credit_limit,      presence: true, on: :save
  validates :phone_number,      presence: true, on: :update

  validates_numericality_of :age,
    greater_than_or_equal_to: 18,
    less_than_or_equal_to: 99,
    only_integer: true
  validates_numericality_of :amount,
    greater_than: :min_amount,
    less_than: :max_amount,
    only_integer: true
  validates_numericality_of :attempts,
    greater_than_or_equal_to: :min_attempts,
    less_than_or_equal_to: :max_attempts,
    only_integer: true
  validates_length_of :name, maximum: 25
  validates_length_of :description, maximum: 50
  validates_length_of :action, maximum: 10, tokenizer: lambda { |str| str.scan(/\w+/) }
  validates_length_of :home_picture, is: 12

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
    greater_than: 17,
    less_than: 100,
    only_integer: true
  validates_numericality_of :amount,
    greater_than: Proc.new { |user| user.age },
    less_than: Proc.new { |user| user.age + 100 },
    only_integer: true
  validates_numericality_of :attempts,
    greater_than_or_equal_to: Proc.new { |user| user.age },
    less_than_or_equal_to: Proc.new { |user| user.age + 100 },
    only_integer: true

  validates_format_of :country, with: /\w+/
  validates_format_of :name, with: Proc.new { /\w+/ }
  validates_format_of :description, without: /\d+/
end

class HashBackedAuthor < Hash
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?; false; end

  def name
    'hash backed author'
  end
end

class UserNumber1And2 < User
end
