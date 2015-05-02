module Preparam
  class TypeOptionError < StandardError
  end

  class ValidationFailedError < StandardError
  end

  class Schema
    include ActiveModel::Validations
    include Virtus.model
    include Validators

    RESERVED_ATTRIBUTE_OPTIONS = %i(default)

    class << self
      def optional(name, type, **options, &block)
        options.reverse_merge!(coercion: true)

        type = build_nested_type(name, type, options, &block) if block_given?

        build_attribute(name, type, options)
        build_validations(name, options)
      end

      def mandatory(name, type, **options, &block)
        optional(name, type, options.merge(presence: true), &block)
      end

      def use
        raise NotImplementedError
      end

      private

      def build_nested_type(name, type, **options, &block)
        options.merge!(associated: true)
        if type == Array
          Array[Class.new(self, &block)]
        elsif type == Hash
          Class.new(self, &block)
        else
          raise TypeOptionError.new("Invalid type '#{type}'")
        end
      end

      def build_attribute(name, type, **options)
        attribute name, type, options.slice(*RESERVED_ATTRIBUTE_OPTIONS)
      end

      def build_validations(name, **options)
        validators = options.except(*RESERVED_ATTRIBUTE_OPTIONS)
        validates name, validators unless validators.empty?
      end
    end

    def valid!
      raise ValidationFailedError unless valid?
    end
  end
end
