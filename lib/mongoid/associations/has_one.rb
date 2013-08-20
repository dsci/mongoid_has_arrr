module Associations
  module HasOne

    def has_one(model_name, opt={})
      options   = extract_ar_options(opt.merge({:model_name => model_name}))
      klass     = options[:klass]
      type_cast = lambda do |value|
        return value.to_s if value.respond_to?(:to_s)
        return value
      end

      define_method(model_name.to_sym) do
        primary_key_value   = self.read_attribute(options[:primary_key])
        where_match         = type_cast.call(primary_key_value)

        return klass.where("#{options[:foreign_key]}" => where_match).first
      end

      define_method("#{model_name}=") do |assoc_model|
        unless assoc_model.class.eql?(klass)
          raise Mongoid::Errors::ActiveRecordRelationsMissmatchError,
                <<-ERROR_MSG.strip_heredoc
                  Object relation missmatch - #{klass} expected but got #{assoc_model.class}
                ERROR_MSG
        end
        primary_key_value   = self.read_attribute(options[:primary_key])
        unless primary_key_value
          raise Mongoid::Errors::ActiveRecordRelationsPrimaryKeyError
        end
        self.class.send(:define_method, model_name.to_sym) do
          return assoc_model
        end
        config              = {
          :primary_key => options[:primary_key],
          :where_match => type_cast.call(primary_key_value),
          :foreign_key => options[:foreign_key],
          :assoc_model => assoc_model
        }
        self.class.ar_has_one_associations << config
      end

      define_method("build_#{model_name}") do |ar_instance_attributes|
        instance = klass.send(:new, ar_instance_attributes)
        self.send("#{model_name}=", instance)
        return instance
      end

      define_method("create_#{model_name}") do |ar_instance_attributes|
        instance = klass.send(:create, ar_instance_attributes)
        self.send("#{model_name}=", instance)
        return instance
      end

    end

  end
end