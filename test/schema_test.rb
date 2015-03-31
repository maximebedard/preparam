require 'test_helper'

class SchemaTest < Minitest::Test

  class TestSchema < Preparam::Schema
    requires :token, String, default: 'n/a'
    requires :name, String

    permits :line_items, Array do
      requires :variant_id, Integer
      requires :quantity, Integer
      permits :properties, Hash, default: {}
    end

    permits :gift_cards, Array do
      requires :code, String
    end

    permits :discount, Hash do
      requires :code, String
      requires :promotion_code, String, default: '50_percent_off'
    end
  end

  def setup
    @params = ActionController::Parameters(name: 'maximebedard',
      line_items: [variant_id:1, quantity:3, properties: {}],
      discount: { code: 'my_awesome_code' })
    @subject = TestSchema.new(@params)
  end

  def test_attributes
    assert_respond_to @subject, :name
    assert_equal @subject.name, 'maximebedard'
  end

  def test_default_value_for_attributes
    assert_respond_to @subject, :token
    assert_equal @subject.token, 'n/a'
  end

  def test_nested_array_attributes
    assert_respond_to @subject.line_items[0].variant_id
    assert_equal @subject.line_items[0].variant_id, 1
  end

  def test_default_value_for_nested_array_attributes
    assert_respond_to @subject.line_items.first, :properties
    assert_equal @subject.line_items.first.properties, {}
  end

  def test_nested_hash_attributes
    assert_respond_to @subject, :discount
    assert_respond_to @subject.discount, :code
    assert_equal @subject.discount.code, 'my_awesome_code'
  end

  def test_default_value_for_nested_hash_attributes
    assert_respond_to @subject, :discount
    assert_respond_to @subject.discount, :promotion_code
    assert_respond_to @subject.discount.promotion_code, '50_percent_off'
  end

  def test_required
  end

  def test_permitted
  end
end
