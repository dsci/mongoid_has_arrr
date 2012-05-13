module Associations

  module BelongsTo

    def belongs_to(model_name, opt={})
      foreign_key = opt.fetch(:foreign_key, "#{model_name.to_s}_id")
      self.send(:field, foreign_key.to_sym, :type => Integer)

      association_klass = opt.fetch(:class, model_name.to_s)

      klass = Module.const_get(association_klass.capitalize)

      define_method(model_name.to_sym) do  
        return klass.find(read_attribute(foreign_key))
      end
  
      define_method("#{model_name}=") do |ar_instance|
        write_attribute(foreign_key,ar_instance.id)
      end

      define_method("create_#{model_name}") do |ar_instance_attributes|
        options = {:mongoid_klass => self, :foreign_key => foreign_key}
        return Associations::Builder.handle_association_with_command( klass,:create,
                                                                      ar_instance_attributes,
                                                                      options)
      end

      define_method("build_#{model_name}") do |ar_instance_attributes|
        options = {:mongoid_klass => self, :foreign_key => foreign_key}
        return Associations::Builder.handle_association_with_command( klass,:new,
                                                                      ar_instance_attributes,
                                                                      options)  
      end
  
    end

  end

end