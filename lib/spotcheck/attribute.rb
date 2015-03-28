module Spotcheck
  class AttributeAlreadyExistsError < StandardError
  end

  module Attribute
    def build_attribute(name, type, value = nil, default = nil)
      self.class.send(:define_method, name) do
        instance_variable_get("@#{name}")
      end unless self.class.method_defined?(name)

      instance_variable_set("@#{name}", default)
      instance_variable_set("@#{name}", value) if value
    end


    private

    def define_getter(name)
      raise AttributeAlreadyExistsError if method_defined?(name)
    end

    def define_setter(name)
      raise AttributeAlreadyExistsError if method_defined?("#{name}=")
    end
  end
end
