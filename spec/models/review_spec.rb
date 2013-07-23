require "spec_helper"

describe Review do

    it{ should allow_value("I liked it very much").for(:title)}
    it{ should validate_presence_of(:body)}
    it{ should allow_value("I liked it very much").for(:body)}
    it{ should ensure_inclusion_of(:note).in_array([*1..5])}
    it{ should_not allow_value("I liked it very much").for(:note)}
    it{ should belong_to(:product)}
    it{ should validate_presence_of(:product)}

    context "to by valid" do
        let(:review_2){ FactoryGirl.build(:review, note: 3)}
        let(:review){FactoryGirl.build(:review)}
        let(:user){ User.new }

        before(:each) do
          user.stub(first_name: "John", last_name: "Smith")
          review_2.stub(user: user)
          review.stub(user: user)
          review_2.save
          review.save
        end
        let(:product){ review.product}

        
        it{ "#{review.reviewer}".should match(/John Smith/) }

        it{
            expect { product.add review: review_2 }.
            to change { product.reviews.rating }.
            from(1).to(2)
        }
    end
end