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
      def permits(name, type, **options, &block)
        type       = build_nested_type(name, type, &block) if block_given?
        validators = options.except(*RESERVED_OPTIONS)

        build_attribute(name, type, options)
        build_validators(name, validators)
      end

      def requires(name, type = nil, **options, &block)
        permits(name, type, options.merge(presence: false), &block)
      end

      def use
        raise NotImplementedError
      end

      private

      def build_nested_type(name, &block)
        raise TypeOptionError.new("Invalid type '#{type}'") unless [Array, Hash].include?(type)
        Class.new(self, &block)
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
