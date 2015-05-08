module Preparam
  class Schema
    include ActiveModel::Validations
    include Virtus.model
    include Validators

    RESERVED_ATTRIBUTE_OPTIONS = %i(default)

    class << self
      def optional(name, type, **options, &block)
        options.reverse_merge!(coercion: true)

        if block_given?
          type = build_nested_type(type, &block)
          options.reverse_merge!(associated: true)
        end

        build_attribute(name, type, options)
        build_validations(name, options)
      end

      def mandatory(name, type, **options, &block)
        optional(name, type, options.merge(presence: true), &block)
      end

      def anything(name, type, **options, &block)
        options.reverse_merge!(associated: false, coercion: false)
        optional(name, type, options, &block)
      end

      def use
        raise NotImplementedError
      end

      private

      def build_nested_type(type, &block)
        anon = Class.new(self, &block).tap do
          def self.model_name
            ActiveModel::Name.new(self, nil, "temp")
          end
        end

        if type == Array
          Array[anon]
        elsif type == Hash
          anon
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
      raise ValidationFailedError(errors) unless valid?
    end
  end
end
