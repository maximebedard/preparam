require 'test_helper'

class SchemaTest < Minitest::Test

  class TestSchema < Preparam::Schema
    requires :token, String, default: 'n/a'
    requires :name, String

    permits :line_items, Array do
      requires :variant_id, Integer, default: 0
      requires :quantity, Integer
      permits :properties, Hash
    end

    permits :gift_cards, Array do
      requires :code, String
    end

    permits :discount, Hash do
      requires :code, String
    end
  end

  def setup
    @subject = TestSchema.new(name: 'maximebedard')
  end

  def test_builded_attributes
    assert_respond_to @subject, :name
    assert_equal @subject.name, 'maximebedard'
  end

  def test_builded_nested_attributes
    assert_respond_to @subject.line_items
    assert_respond_to @subject.line_items
  end

  def test_default_value_for_attributes
    assert_respond_to @subject, :token
    assert_equal @subject.token, 'n/a'
  end

  def xtest_define_validators
  end

  def xtest_valid?
  end

  def xtest_make_permits
  end
end
