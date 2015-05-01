module Preparam
  class TypeOptionError < StandardError
  end

  class ValidationFailedError < StandardError
  end

  class Schema
    include ActiveModel::Validations
    include Virtus.model

    RESERVED_OPTIONS = %i(default)

    class << self
      def optional(name, type, **options, &block)
        type       = build_nested_type(name, type, &block) if block_given?
        validators = options.except(*RESERVED_OPTIONS)

        build_attribute(name, type, options)
        build_validators(name, validators)
      end

      def mandatory(name, type, **options, &block)
        optional(name, type, options.merge(presence: true), &block)
      end

      def use
        raise NotImplementedError
      end

      private

      def build_nested_type(name, type, &block)
        if type == Array
          Array[Class.new(self, &block)]
        elsif type == Hash
          Class.new(self, &block)
        else
          raise TypeOptionError.new("Invalid type '#{type}'")
        end
      end

      def build_attribute(name, type, **options)
        attribute name, type, options.slice(*RESERVED_OPTIONS)
      end

      def build_validators(name, validators)
        validates name, validators unless validators.empty?
      end
    end

    def valid!
      raise ValidationFailedError unless valid?
    end
  end
end
