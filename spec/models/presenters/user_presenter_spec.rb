require "spec_helper"

describe UserPresenter do
  it{ should respond_to(:full_name)}

  let(:user){ FactoryGirl.create(:user)}
  let(:user_presenter){ UserPresenter.new user}
  subject{ user_presenter}

  describe "#full_name" do
    its(:full_name){ should eq("#{user.first_name} #{user.last_name}")}
  end

  describe "display_name" do
    let(:guest){ UserPresenter.new(FactoryGirl.build(:user, :guest)) }
    it{ 
      expect{ user_presenter.user.nick = "Nick"}
      .to change{ "#{user_presenter}"}
      .from("#{user.first_name} #{user.last_name}")
      .to("Nick")
    }
    it{ guest.to_s.should eq("Guest")}
  end

  describe "user delegation" do
    its(:guest?){ should be_false}
    its(:admin?){ should be_false}
    it{ expect{ user_presenter.some_unknown_method}.to raise_error}
  end

end