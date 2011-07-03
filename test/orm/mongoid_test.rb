require 'simple_form/orm/mongoid'
require 'test_helper'

class MongoidForm
  include SimpleForm::Orm::Mongoid
end

# TODO: Use relations from actual Mongoid.
module Mongoid
  module Relations
    module Referenced
      class In
        def macro; :referenced_in; end
      end
      class One
        def macro; :references_one; end
      end
      class Many
        def macro; :references_many; end
      end
    end
    module Embedded
      class In
        def macro; :embedded_in; end
      end
      class One
        def macro; :embeds_one; end
      end
      class Many
        def macro; :embeds_many; end
      end
    end
  end
end

class MongoidTest < Test::Unit::TestCase
  def test_belongs_to_returns_singular_id
    reflection = Object.new
    reflection.expects(:name).returns("door")
    reflection.expects(:relation).returns Mongoid::Relations::Referenced::In.new
    result = MongoidForm.new.find_attribute_column_by_reflection reflection
    assert_equal :door_id, result
  end

  def test_has_one_returns_singular_id
    reflection = Object.new
    reflection.expects(:name).returns("door")
    reflection.expects(:relation).returns Mongoid::Relations::Referenced::One.new
    result = MongoidForm.new.find_attribute_column_by_reflection reflection
    assert_equal :door_id, result
  end

  def test_has_many_returns_singular_ids
    reflection = Object.new
    reflection.expects(:name).returns("doors")
    reflection.expects(:relation).returns Mongoid::Relations::Referenced::Many.new
    result = MongoidForm.new.find_attribute_column_by_reflection reflection
    assert_equal :door_ids, result
  end

  def test_embedded_in_returns_singular
    reflection = Object.new
    reflection.expects(:name).returns("door")
    reflection.expects(:relation).returns Mongoid::Relations::Embedded::In.new
    result = MongoidForm.new.find_attribute_column_by_reflection reflection
    assert_equal :door, result
  end

  def test_embedds_one_returns_singular
    reflection = Object.new
    reflection.expects(:name).returns("door")
    reflection.expects(:relation).returns Mongoid::Relations::Embedded::One.new
    result = MongoidForm.new.find_attribute_column_by_reflection reflection
    assert_equal :door, result
  end

  def test_embeds_many_returns_plural
    reflection = Object.new
    reflection.expects(:name).returns("doors")
    reflection.expects(:relation).returns Mongoid::Relations::Embedded::Many.new
    result = MongoidForm.new.find_attribute_column_by_reflection reflection
    assert_equal :doors, result
  end
end
