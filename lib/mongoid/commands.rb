module Associations
  module Commands

    class Base

      def self.pattern(regexp)
        define_method :cmd_pattern do
          return regexp
        end
      end

      def match?(cmd)
        cmd =~ Regexp.new(/#{cmd_pattern}/)
      end
    end

    class Create < Base

      pattern :create

      def run_cmd(mongoid_klass,foreign_key, instance)
        mongoid_klass.send(:write_attribute, foreign_key,
                           instance.id)
      end

    end

    class New < Base

      pattern :new

      def run_cmd(mongoid_klass,foreign_key, instance)
        config = {
          :instance => instance,
          :foreign_key => foreign_key
        }
        mongoid_klass.class.ar_belongs_to_associations << config

      end
    end

    class Nil < Base

      pattern :nil

      def run_cmd(mongoid_klass,foreign_key,instance)
      end
    end

  end
end