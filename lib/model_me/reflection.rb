module ModelMe
  module Reflection
    extend ActiveSupport::Concern

    included do
      class_attribute :reflections
      self.reflections = {}
    end

    module ClassMethods
      def create_reflection(macro, name, options, model)
        case macro
        when :has_many, :belongs_to, :has_one
          reflection = Reflection::AssociationReflection.new(macro, name, options, model)
        else
          raise NotImplementedError, "ModelMe does not currently support #{macro} associations."
        end

        self.reflections = self.reflections.merge(name => reflection)
        reflection
      end

      def reflect_on_association(association)
        self.reflections[association].is_a?(Reflection::AssociationReflection) ? reflections[association] : nil
      end
    end

    class MacroReflection
      attr_reader :model, :name, :macro, :options

      def initialize(macro, name, options, model)
        @macro, @name, @options, @model = macro, name, options, model
      end

      def klass
        @klass ||= class_name.constantize
      end

      def class_name
        @class_name ||= options[:class_name] || derive_class_name
      end
    end

    class AssociationReflection < MacroReflection
      def initialize(macro, name, options, model)
        super
        @collection = macro.in?([:has_many])
      end

      def foreign_key
        @foreign_key ||= options[:foreign_key] || derive_foreign_key
      end

      def association_foreign_key
        @association_foreign_key ||= @options[:association_foreign_key] || class_name.foreign_key
      end

      def collection?
        @collection
      end

      def belongs_to?
        macro == :belongs_to
      end

      private

      def derive_class_name
        class_name = name.to_s.camelize
        class_name = class_name.singularize if collection?
        class_name
      end

      def derive_foreign_key
        if belongs_to?
          "#{name}_id"
        else
          model.name.foreign_key
        end
      end
    end
  end
end
