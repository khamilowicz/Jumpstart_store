require "spec_helper"

describe Session do
  let(:user){ User.new}
  before(:each) do
    user.stub(:valid?){true}
    user.email = "realemail"
    user.password = 'secret'
    user.save
  end

  it "should not authenticate user with email not in database" do
    Session.authenticate({email: "someemail", password: 'secret'}).should be_nil
  end

  it "should return user with correct email and password" do
    Session.authenticate({email: user.email, password: 'secret'}).should eq(user)
  end
end