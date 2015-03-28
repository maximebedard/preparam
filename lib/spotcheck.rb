require 'active_support'
require 'active_support/core_ext'
require 'action_controller'
require 'active_model'

require 'spotcheck/version'
require 'spotcheck/attribute'

module Spotcheck
  autoload :Schema, 'spotcheck/schema'
end


module ActionController
  class Base
    def params
      return super unless block_given?
      Spotcheck::Schema.new(super, nil, &block)
    end
  end
end
