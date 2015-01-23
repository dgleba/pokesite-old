require 'rails_helper'

RSpec.describe User::Account, :type => :model do
  let(:user) { FactoryGirl.create(:user_account) }

  context "username" do
    it "is required" do
      u = FactoryGirl.build(:user_account, username: "")
      expect(u).to be_invalid
    end

    it "is unique" do
      u = FactoryGirl.build(:user_account, username: user.username)
      expect(u).to be_invalid
    end

    it "may only contain letters, numbers, and underscores" do
      u = FactoryGirl.build(:user_account, username: "Invalid @Username")
      expect(u).to be_invalid
    end
  end

  context "to_param" do
    it "returns the username" do
      expect(user.to_param).to eql(user.username)
    end
  end

  context "to_s" do
    it "returns the username" do
      expect(user.to_s).to eql(user.username)
    end
  end
end
