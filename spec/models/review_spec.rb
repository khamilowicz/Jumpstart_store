require "spec_helper"

describe "Review" do

  context "to by valid" do

    subject{FactoryGirl.create(:review)}

    it "has title" do
      subject.title = nil
      should_not be_valid
      subject.title = "Review title"
      should be_valid
    end

    it "has body" do
      subject.body = "I liked it very much"
      subject.body.should =="I liked it very much"
    end

    it "has note" do
     subject.note = 5
     subject.note.should == 5
   end

   it "note should be number from 1 to 5" do
     subject.note = 0
     subject.should_not be_valid
     subject.note = 6
     subject.should_not be_valid
     subject.note = 1
     subject.should be_valid
     subject.note = 2.5
     subject.should_not be_valid
   end


   it "has name of the reviewer" do
    user = FactoryGirl.build(:user, first_name: "John", last_name: "Smith")
    subject.user = user
    subject.reviewer_name.should == "John Smith"
  end

  it "belongs to a product" do
    subject.product = nil
    subject.should_not be_valid
    subject.product = FactoryGirl.create(:product)
    subject.should be_valid
  end
end
end