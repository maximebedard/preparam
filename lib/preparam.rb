require 'active_support/all'
require 'action_controller'
require 'active_model'
require 'virtus'

require 'preparam/version'
require 'preparam/schema'

module Preparam
  module Ext
    def preparam
    end

    def preparam_with
    end
  end
end

ActionController::Base.include Preparam::Ext
