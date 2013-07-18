require "spec_helper"

describe Session do
  let(:user){ FactoryGirl.create(:user)}
  let(:user_2){ FactoryGirl.create(:user)}

  it "should not authenticate user with email not in database" do
    Session.authenticate({email: "someemail", password: 'secret'}).should be_nil
  end

  it "should return user with correct email and password" do
    Session.authenticate({email: user.email, password: 'secret'}).should eq(user)
  end
end