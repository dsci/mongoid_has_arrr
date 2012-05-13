Dir[File.expand_path(File.join(File.dirname(__FILE__), 'associations', '*.rb'))].each{|stuff| require stuff}
module Mongoid
  module ActiveRecordRelations

    extend self

    def included(base)
      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods

      def with_active_record
        self.extend(Associations::BelongsTo)
        yield self if block_given?
      end

      def ar_associations
        @ar_assocs ||= []
      end
    end

    module InstanceMethods

      def save
        self.class.ar_associations.each do |assoc|
          assoc_klass = assoc[:instance]
          assoc_klass.save
          write_attribute(assoc[:foreign_key], assoc_klass.send(:id))
        end
        super
      end

    end

  end

end