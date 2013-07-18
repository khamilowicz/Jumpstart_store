require "spec_helper"

describe "Review" do

  context "to by valid" do
    let(:user){ FactoryGirl.build(:user, first_name: "John", last_name: "Smith") }
    subject{FactoryGirl.create(:review, user: user)}
    let(:review_2){ FactoryGirl.create(:review, user: user, note: 3)}
    let(:product){ subject.product}

    it{ should allow_value("I liked it very much").for(:title)}
    it{should validate_presence_of(:body)}
    it{ should allow_value("I liked it very much").for(:body)}
    it{ should ensure_inclusion_of(:note).in_array([*1..5])}
    it{ should_not allow_value("I liked it very much").for(:note)}

it{ subject.reviewer.to_s.should eq("John Smith") }

    it{ should belong_to(:product)}
    it{ should validate_presence_of(:product)}

    it{ product.reviews.rating.should == 1}
    it{
        expect { product.add review: review_2 }.
        to change { product.reviews.rating }.
        from(1).to(2)
    }
  end

end