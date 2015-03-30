require 'active_support'
require 'active_support/core_ext'
require 'action_controller'
require 'active_model'
require 'virtus'

require 'preparam/version'

module Preparam
  autoload :Schema, 'preparam/schema'
end


module ActionController
  class Base
    def perparam(&block)
      #Preparam::Schema.define(params, nil, &block)
    end

    def preparam_with(schema)
      #schema.define(params, nil)
    end
  end
end
