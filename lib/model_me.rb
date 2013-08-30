require 'active_support'
require 'active_support/core_ext'
require 'active_model'

require 'model_me/version'
require 'model_me/errors'

module ModelMe
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Adapters
  autoload :Attribute
  autoload :AttributeMethods
  autoload :Configuration
  autoload :Errors
  autoload :Identity
  autoload :Logging
  autoload :Persistence
  autoload :Predicate
  autoload :Validation
end
