module Associations
  module Optionize

    def extract_ar_options(opt)
      association_klass     = opt.fetch(:class, opt[:model_name].to_s)
      {
        :foreign_key       => opt.fetch(:foreign_key, self.name.foreign_key),
        :primary_key       => opt.fetch(:primary_key, "_id"),
        :association_klass => association_klass,
        :foreign_key_type  => opt.fetch(:foreign_key_type, :String),
        :klass             => association_klass.classify.constantize
      }
    end

  end
end