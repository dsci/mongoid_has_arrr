module Associations

  module BelongsTo

    def belongs_to(model_name, opt={})
      opt.merge!({:model_name => model_name})
      unless opt.has_key?(:foreign_key)
        opt[:foreign_key] = "#{model_name}_id"
      end
      options = extract_ar_options(opt)
      klass   = options[:klass]
      self.send(:field, options[:foreign_key].to_sym, :type => Integer)

      define_method(model_name.to_sym) do
        return klass.find(read_attribute(options[:foreign_key]))
      end

      define_method("#{model_name}=") do |ar_instance|
        unless ar_instance.class.eql?(klass)
          raise Mongoid::Errors::ActiveRecordRelationsMissmatchError,
                <<-ERROR_MSG.strip_heredoc
                  Object relation missmatch - #{klass} expected but got #{assoc_model.class}
                ERROR_MSG
        end
        write_attribute(options[:foreign_key],ar_instance.id)
      end

      define_method("create_#{model_name}") do |ar_instance_attributes|
        options = {
          :mongoid_klass  => self,
          :foreign_key    => options[:foreign_key]
        }
        return Associations::Builder.
              handle_association_with_command( klass,:create,
                                               ar_instance_attributes,
                                               options)
      end

      define_method("build_#{model_name}") do |ar_instance_attributes|
        options = {
          :mongoid_klass => self,
          :foreign_key => options[:foreign_key]
        }
        return Associations::Builder.
              handle_association_with_command( klass,:new,
                                               ar_instance_attributes,
                                               options)
      end

    end

  end

end