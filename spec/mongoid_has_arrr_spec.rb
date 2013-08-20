# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "MongoidHasArrr" do

  describe "Relations to ActiveRecord Model(s)" do

    after(:all) do
      FileUtils.rm_rf(File.join(File.dirname(__FILE__), 'db', 'test.sqlite3'))
    end

    context "#belongs_to" do

      before do
        @book = Book.new(:title => "Wer einmal aus dem Blechnapf frisst")
      end

      subject{ @book }

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

      context "build association" do

        before do
          @address = subject.build_address(:name => "Leipzig")
        end

        it "successfully" do
          @address.should be_instance_of City
          subject.save
        end
      end

      context "create association" do

        before do
          @address = subject.create_address(:name => "Leipzig")
        end

        it "successfully" do
          @address.should be_instance_of City
          subject.address.id.should be @address.id
          subject.address.name.should == @address.name
        end
      end


    end

    context "#has_one" do

      before do
        @book = Book.new(:title => "Jeder stirbt für sich allein.")
      end

      subject{ @book }

      it{ should respond_to(:publisher) }

      it "gets the ActiveRecord Model that has the Mongoid document" do
        subject.save
        publisher = Publisher.new(:name => "Random House")
        publisher.book_id = subject.id.to_s
        publisher.save
        subject.publisher.id.should eq publisher.id
      end

      it "assigns the ActiveRecord model with a setter method" do
        publisher = Publisher.new(:name => "Aufbau Verlag")
        subject.publisher = publisher
        subject.publisher.should be publisher
        subject.save
        subject.publisher.id.should eq publisher.id
      end

      context "different foreign_key" do

        before do
          Editor.all.each{ |editor| editor.destroy }
        end

        it "gets the ActiveRecord Model that has the Mongoid document" do
          subject.test_id = 12
          subject.save
          editor = Editor.new(:name => "Kay Falsch", :edited_book_id => 12)
          editor.save
          subject.editor.id.should eq editor.id
        end

        it "assigns the ActiveRecord model with a setter method" do
          editor = Editor.new(:name => "Petr Havel")
          subject.test_id = 15
          subject.editor = editor
          subject.editor.should be editor
          subject.save
          subject.editor.id.should eq editor.id

          book = Book.find(subject.id)
          book.editor.should eq editor
        end

      end

      context "different class" do

        it "gets the ActiveRecord Model that has the Mongoid document" do
          subject.save
          price = Publishing::Price.new(:value => 10.99)
          price.book_id = subject.id.to_s
          price.save
          subject.price.id.should eq price.id
        end

        it "assigns the ActiveRecord model with a setter method" do
          price = Publishing::Price.new(:value => 7.99)
          subject.price = price
          subject.price.should be price
          subject.save
          subject.price.id.should eq price.id
        end
      end

      context "build association" do

        it{ should respond_to(:build_editor) }

        before do
          @book      = Book.new
          @publisher = @book.build_publisher(:name => "Copress")
        end

        it "successfully" do
          @publisher.should be_instance_of Publisher
          @book.save
          Book.find(@book.id).publisher.name.should eq "Copress"
        end

      end

      context "create association" do

        it{ should respond_to(:create_editor) }

        before do
          @book         = Book.new(:title => "Kleiner Mann was nun?")
          @book.test_id = 99
          @editor       = @book.create_editor(:name => "Arnold Robbins")
          @publisher    = @book.create_publisher(:name => "Insel Verlag")
          @price        = @book.create_price(:value => 12.99)
          @book.save
        end

        it "successfully" do
          @editor.should be_instance_of Editor
          @book.editor.id.should be @editor.id
          @book.editor.name.should == @editor.name
          @book.publisher.name.should == @publisher.name
          @book.publisher.id.should == @publisher.id
          @book.price.value.should == @price.value
          @book.price.id.should == @price.id
          @price.book_id.should == @book.id.to_s
        end
      end

      context "wrong instance" do

        it "raises a Mongoid::Errors::ActiveRecordRelationsMissmatchError" do
          book = Book.new
          book.test_id = 782
          expect do
            book.editor = Publisher.new(:name => "Aufbau Verlag")
          end.to raise_error(Mongoid::Errors::ActiveRecordRelationsMissmatchError)

        end

      end

    end

  end

end
