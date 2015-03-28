module Preparam
  class TypeOptionError < StandardError
  end

  class ValidationFailedError < StandardError
  end

  class Schema
    include ActiveModel::Validations
    include Attribute

    RESERVED_OPTIONS = %i(is_a default)

    attr_reader :parent, :params, :children

    def initialize(params, parent, &block)
      @params = params
      @parent = parent
      @children = []
      @attributes = []

      if block_given? && block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end

    def permits(param, **options, &block)
      validators = options.except(RESERVED_OPTIONS)

      build_nested_schema(param, options, &block) if block_given?
      build_attribute(param, options[:is_a], params.try(:[], param), options[:default])
    end

    def requires(param, **options, &block)
      permits(param, options.merge(presence: false), &block)
    end

    def use(schema)
      raise NotImplementedError
    end

    def valid?
      super && @children.each(&:valid?).all?
    end
    alias_method :validate, :valid?

    def valid!
      raise ValidationFailedError unless valid?
    end

    private

    def build_nested_schema(param, **options, &block)
      type = options[:is_a]
      raise TypeOptionError unless [Array, Hash].include?(type)

      @children << Schema.new(params.try(:[], param), self, &block)
    end
  end
end
