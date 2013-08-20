require 'mongoid/optionize'
require 'mongoid/commands'
Dir[File.join(File.dirname(__FILE__), 'associations', '*.rb')].each do |stuff|
  require stuff
end
module Mongoid

  module Errors

    class ActiveRecordRelationsMissmatchError < ::StandardError
    end

    class ActiveRecordRelationsPrimaryKeyError < ::StandardError

      def message
        "Primary key is empty or nil."
      end
    end

  end

  module ActiveRecordRelations

    extend self

    def included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods

      def with_active_record
        self.extend(Associations::Optionize)
        self.extend(Associations::BelongsTo)
        self.extend(Associations::HasOne)
        yield self if block_given?
      end

      def ar_belongs_to_associations
        @ar_assocs ||= []
      end

      def ar_has_one_associations
        @ar_has_one_associations ||= []
      end
    end

    module InstanceMethods

      # Add has_one here
      def save
        assoc_save_conf.each_pair do |key,value|
          value.call(self.class.send(key))
        end
        super
      end

      private

      def assoc_save_conf
        {
          :ar_belongs_to_associations => lambda do |associations|
            associations.each do |assoc|
              assoc_klass = assoc[:instance]
              assoc_klass.save
              write_attribute(assoc[:foreign_key], assoc_klass.send(:id))
            end
          end,
          :ar_has_one_associations => lambda do |associations|
            associations.each do |assoc|
              fk    = assoc[:foreign_key]
              model = assoc[:assoc_model]
              model.send("#{fk}=", assoc[:where_match])
              model.save
            end

          end
        }
      end

    end

  end

end