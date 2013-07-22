require "spec_helper"

describe UserPresenter do
  it{ should respond_to(:full_name)}

  let(:user){ User.new}
  let(:user_presenter){ UserPresenter.new user}
  subject{ user_presenter}

  before(:each) do 
    user.stub(:first_name){'John'}
    user.stub(:last_name){'Smith'}
  end

  it{ 
    expect{ user.nick = "Nick"}
    .to change{ "#{user_presenter}"}
    .from("John Smith")
    .to("Nick")
  }

  describe "#full_name" do
    its(:full_name){ should eq("John Smith")}
  end

  describe "display_name" do
    before(:each) do 
      user.stub(:guest?){true}
    end

    it{ "#{user_presenter}".should eq("Guest")}
  end

  describe "user delegation" do
    its(:guest?){ should be_false}
    its(:admin?){ should be_false}
    it{ expect{ user_presenter.some_unknown_method}.to raise_error}
  end
end