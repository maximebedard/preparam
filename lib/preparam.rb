require 'active_support'
require 'active_support/core_ext'
require 'action_controller'
require 'active_model'

require 'preparam/version'
require 'preparam/attribute'

module Preparam
  autoload :Schema, 'preparam/schema'
end


module ActionController
  class Base
    def params
      return super unless block_given?
      Preparam::Schema.new(super, nil, &block)
    end
  end
end
