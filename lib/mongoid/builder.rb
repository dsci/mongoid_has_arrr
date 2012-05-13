module Associations

  module Builder
    extend self

    def handle_association_with_command(active_record,cmd, attributes, mongoid_options = {})
      mongoid_klass = mongoid_options.fetch(:mongoid_klass, nil)
      foreign_key   = mongoid_options.fetch(:foreign_key, nil)
      instance_of_association = active_record.send(cmd.to_sym, attributes)
      unless mongoid_klass.nil?
        case cmd
        when :create  then mongoid_klass.send(:write_attribute, foreign_key, instance_of_association.id)
        when :new     then mongoid_klass.class.ar_associations << { :instance => instance_of_association, 
                                                                    :foreign_key => foreign_key}
        end
      end
      return instance_of_association
    end
  end
  
end