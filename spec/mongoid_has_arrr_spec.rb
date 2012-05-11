require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class Author < ActiveRecord::Base

end

class Label < ActiveRecord::Base

end

class City < ActiveRecord::Base

end

class Book

  include Mongoid::Document
  include Mongoid::ActiveRecordRelations

  field :title,       :type => String
  #field :author_id,   :type => Integer
  #field :this_one_id, :type => Integer


  with_active_record do 
    belongs_to :author
    belongs_to :label, :foreign_key => "this_one_id"
    belongs_to :address, :foreign_key => "city_id", :class => "City"
  end

end

describe "MongoidHasArrr" do
  
  describe "Relations to ActiveRecord Model(s)" do

    context "#belongs_to" do

      before do
        @book = Book.new(:title => "Wer einmal aus dem Blechnapf frisst")
      end

      subject{@book}

      it{should respond_to(:author)}
      it{should respond_to(:label)}
      it{should respond_to(:label=)}
      it{should respond_to(:author=)}

      it "assigns the ActiveRecord model with a setter method" do
        author = Author.create(:name => "Hans Fallada")
        subject.author=author
        subject.author_id.should eq author.id
      end

      it "gets the ActiveRecord model it belongs to" do
        author = Author.create(:name => "Hans Fallada")
        subject.author_id = author.id
        subject.save

        subject.author.should be_instance_of Author
        subject.author.id.should be author.id
      end

      context "different foreign_key" do
        
        before do
          @label = Label.create(:identifier => "Random House")
          subject.label=@label
        end

        it "gets the ActiveRecord model it belongs to" do
          subject.label.id.should eq @label.id
          subject.label.identifier.should eq @label.identifier
        end

      end

      context "different class" do

        before do
          @city = City.create(:name => "Leipzig")
          subject.address = @city
          subject.save
        end

        it "gets the ActiveRecord model it belongs to" do
          subject.address.id.should eq @city.id
          subject.address.name.should eq @city.name
        end


      end



    end

  end

end
