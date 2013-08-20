module Associations

  module Builder
    extend self

    def handle_association_with_command(active_record,cmd, attributes,
                                        mongoid_options = {}
                                        )
      mongoid_klass = mongoid_options.fetch(:mongoid_klass, nil)
      foreign_key   = mongoid_options.fetch(:foreign_key, nil)
      instance_of_association = active_record.send(cmd.to_sym, attributes)

      cmds    = [Commands::Create.new, Commands::New.new, Commands::Nil.new]
      runner  = cmds.find do |cmd_klass|
        cmd_klass.match?(cmd)
      end
      runner.run_cmd(mongoid_klass, foreign_key,instance_of_association )
      return instance_of_association
    end

  end

end