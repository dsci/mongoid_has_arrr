class Book

  include Mongoid::Document
  include Mongoid::ActiveRecordRelations

  field :title,       :type => String
  field :test_id,     :type => Integer
  #field :author_id,   :type => Integer
  #field :this_one_id, :type => Integer


  with_active_record do
    belongs_to :author
    belongs_to :label, :foreign_key => "this_one_id"
    belongs_to :address, :foreign_key => "city_id", :class => "City"

    has_one :publisher
    has_one :editor, :foreign_key => "edited_book_id",
                     :primary_key => "test_id",
                     :foreign_key_type => :Integer
    has_one :price,  :class => "Publishing::Price"
  end

end