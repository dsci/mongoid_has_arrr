module Mongoid

  module ActiveRecordRelations

    extend self

    def included(base)
      base.send(:extend, ClassMethods)
      #base.send(:include, InstanceMethods)
    end

    module ClassMethods

      def with_active_record
        self.extend(Associations)
        yield self if block_given?
      end

      module Associations

        def belongs_to(model_name, opt={})
          foreign_key = opt.fetch(:foreign_key, "#{model_name.to_s}_id")
          self.send(:field, foreign_key.to_sym, :type => Integer)

          association_klass = opt.fetch(:class, model_name.to_s)
          define_method(model_name.to_sym) do
            klass = Module.const_get(association_klass.capitalize)
            return klass.find(read_attribute(foreign_key))
          end
  
          define_method("#{model_name}=") do |ar_instance|
            write_attribute(foreign_key,ar_instance.id)
          end
  
        end

      end

    end

  end

end