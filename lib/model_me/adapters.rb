module ModelMe
  class AdapterNotSpecified < ModelMeError; end
  class InvalidAdapter < ModelMeError; end
  class InvalidSpecification < ModelMeError; end

  module Adapters
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :AbstractAdapter
    autoload :AdapterManager
    autoload :AdapterPool
    autoload :AdapterSpecification

    included do
      class_attribute :adapter_manager
      self.adapter_manager = ModelMe::Adapters::AdapterManager.new
    end

    def adapter
      self.class.retrieve_adapter
    end

    module ClassMethods

      def register_adapter(name, klass)
        unless klass.ancestors.include?(ModelMe::Adapters::AbstractAdapter)
          raise InvalidAdapter, "Invalid adapter: #{klass}"
        end
        AdapterManager.register(name, klass)
      end

      def set_adapter(spec = nil)
        case spec
        when nil
          raise AdapterNotSpecified unless defined?(Rails) && Rails.respond_to?(:env)
          set_adapter(Rails.env)
        when Symbol, String
          if s = ModelMe::Base.specs[spec.to_sym]
            set_adapter(s)
          else
            raise InvalidSpecification, "#{spec} is not configured"
          end
        when AdapterSpecification
          self.adapter_manager.create_adapter(name, spec)
        end
      end
    end
  end
end
