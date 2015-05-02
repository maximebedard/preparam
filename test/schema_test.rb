require 'test_helper'

class SchemaTest < Minitest::Test

  class CartSchema < Preparam::Schema
    mandatory :token, String, default: 'n/a'
    mandatory :name, String

    optional :line_items, Array do
      mandatory :variant_id, Integer
      mandatory :quantity, Integer
      optional :properties, Hash, default: {}
      optional :adjustments, Array do
        optional :price, Money
      end
    end

    optional :gift_cards, Array do
      mandatory :code, String
    end

    optional :discount, Hash do
      mandatory :code, String
    end
  end

  def setup
    @params = {
      name: 'maximebedard',
      line_items: [{variant_id:1, quantity:3, properties: {}}],
      discount: { code: 'my_awesome_code' }
    }
    @subject = CartSchema.new(@params)
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
    assert_respond_to @subject, :line_items
    assert_instance_of Array, @subject.line_items
    refute_empty @subject.line_items
    assert_respond_to @subject.line_items[0], :variant_id
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

  class SimpleMandatorySchema < Preparam::Schema
    mandatory :name, String
  end

  def test_mandatory_parameter_not_present
    refute SimpleMandatorySchema.new.valid?
  end

  def test_mandatory_parameter_present
    assert SimpleMandatorySchema.new(name: 'Bedard').valid?
  end

  def test_mandatory_parameter_coercion
    refute SimpleMandatorySchema.new(name: {}).valid?
  end

  class SimpleOptionalSchema < Preparam::Schema
    optional :name, String
  end

  def test_optional_parameter_not_present
    assert SimpleOptionalSchema.new.valid?
  end

  def test_optional_parameter_present
    assert SimpleOptionalSchema.new(name: 'Bedard').valid?
  end

  def test_optional_parameter_coercion
    refute SimpleOptionalSchema.new(name: {}).valid?
  end
end
