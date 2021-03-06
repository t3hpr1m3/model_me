require 'model_me/errors'

module ModelMe
  #
  # ModelMe objects are based on ActiveModel (they include all of the
  # standard ActiveModel modules).  They also include a lot of syntatic sugar
  # to allow them to interoperate with ActiveRecord.
  #
  # ModelMe objects are meant to be used in situations when the data they
  # represent is not stored in a database, and might not even be OO in nature
  # (ie. procedural calls to a legacy system are required to access data and
  # perform transactions).  Instead of data access being handled by ModelMe
  # itself, it is delegated to one or more adapters defined by the user,
  # registered with ModelMe.
  #
  # == ActiveModel
  #
  # ModelMe models are fully ActiveModel compliant, meaning they can be used
  # in standard Rails forms, just like ActiveRecord objects.
  #
  # == Definition
  #
  # Defining a model that derives from ModelMe is a 2 step process:
  #
  # 1. Define the model itself
  #
  #     class Transfer < ModelMe::Base
  #       attribute :from, :integer
  #       attribute :to, :integer
  #       attribute :amount, :float
  #     end
  #
  # 2. Define the backing module that provides the data access layer:
  #
  #     module MyAdapter
  #       module Transfer
  #         def create(model)
  #         end
  #
  #         def read(query)
  #         end
  #
  #         def update(model)
  #         end
  #
  #         def destroy(model)
  #         end
  #       end
  #     end
  #
  # More about adapters and backing modules can be found in {ModelMe::Adapters}.
  #
  # == Construction
  #
  # ModelMe accepts attributes either in a hash or as a block.  The hash
  # method is handy when you obtained the attributes from another source:
  #
  #   transfer = Transfer.new(from: 123, to: 321, amount: 10.00)
  #   transfer.amount # => 10.00
  #
  # You can also specify a block for initialization:
  #
  #   transfer = Transfer.new do |t|
  #     t.from = 123
  #     t.to = 321
  #     t.amount = 10.00
  #   end
  #
  # You can also assign the attributes directly after construction:
  #
  #   transfer = Transfer.new
  #   transfer.from = 123
  #   transfer.to = 321
  #   transfer.amount = 10.00
  #
  # == Associations
  class Base
    extend Configuration
    include AttributeMethods
    include Identity
    include Persistence
    include Serialization
    include Validation
    include Adapters
    include Reflection
    extend ActiveModel::Translation
    extend ActiveModel::Naming

    # Instantiates a new instance of an ModelMe.
    #
    # New objects can either be created as empty (pass no attributes), or with 
    # predefined values but not yet saved (pass a hash with keys that match the
    # names of defined attributes).
    #
    # In either instance, any attributes that are not specified will be
    # initialized with either the default value specified on the attribute
    # declaration, or nil.
    #
    # ==== Example:
    #   # Instantiates a new Transfer object
    #   Transfer.new(from: 123, to: 321, amount: 10.00)
    #
    def initialize(attributes = nil)
      defaults = self.class.attribute_defaults.dup
      @attributes = self.class.initialize_attributes(defaults)

      @persisted = false
      @destroyed = false
      @readonly = true

      assign_attributes(attributes) if attributes
    end
  end
end
