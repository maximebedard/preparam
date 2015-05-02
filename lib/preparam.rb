require 'active_support/all'
require 'action_controller'
require 'active_model'
require 'virtus'

require 'preparam/version'
require 'preparam/validators/associated_validator'
require 'preparam/validators/coercion_validator'
require 'preparam/schema'

module Preparam
  module Extensions
    def preparam
    end

    def preparam_with
    end
  end
end

ActionController::Base.include Preparam::Extensions
