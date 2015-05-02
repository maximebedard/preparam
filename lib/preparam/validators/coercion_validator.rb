module Preparam
  module Validators
    class CoercionValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        return if value.nil?
        return if record.class.attribute_set[attribute].value_coerced?(value)
        record.errors.add(attribute, :invalid, options.merge(value: value))
      end
    end
  end
end
