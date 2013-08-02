require 'spec_helper'

describe Report do
  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is wrong!
    @report = Report.new(content: "Lorem ipsum", user_id: user.id)
  end

  subject { @report }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @report.user_id = nil }
    it { should_not be_valid }
  end
end