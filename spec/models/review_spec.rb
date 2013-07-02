require "spec_helper"

describe "Review" do

  context "to by valid" do
    let(:user){ FactoryGirl.build(:user, first_name: "John", last_name: "Smith") }
    subject{FactoryGirl.create(:review, user: user)}

    it{should validate_presence_of(:title)}
    it{ should allow_value("I liked it very much").for(:title)}
    it{should validate_presence_of(:body)}
    it{ should allow_value("I liked it very much").for(:body)}
    it{ should ensure_inclusion_of(:note).in_array([*1..5])}
    it{ should_not allow_value("I liked it very much").for(:note)}

    its(:reviewer_name){should eq("John Smith")}

    it{ should belong_to(:product)}
    it{ should validate_presence_of(:product)}
  end
end