require 'test_helper'

class SchemaTest < Minitest::Test
  def setup
    @params = ActionController::Parameters.new(name: 'maximebedard')
    @subject = Preparam::Schema.new(@params, nil) do
      requires :token, is_a: String, default: 'n/a'
      requires :name, is_a: String

      permits :line_items, is_a: Array do
        requires :variant_id, is_a: Integer
        requires :quantity, is_a: Integer
        permits :properties, is_a: Hash
      end

      permits :gift_cards, is_a: Array do
        requires :code, is_a: String
      end

      permits :discount, is_a: Hash do
        requires :code, is_a: String
      end
    end
  end

  def test_builded_attributes
    assert_respond_to @subject, :name
    assert_equal @subject.name, 'maximebedard'
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
