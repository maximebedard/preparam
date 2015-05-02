module Preparam
  module Validators
    class AssociatedValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        if Array.wrap(value).any?
          record.errors.add(attribute, :invalid, options.merge(value: value))
        end
      end
    end
  end
end
