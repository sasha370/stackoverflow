require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should belong_to :linkable }
  it { should allow_value('http://www.google.com').for(:url) }
  it { should_not allow_value("Inv4lid_").for(:url) }

  let(:question) { create(:question) }
  let(:link) { create(:link, linkable: question) }
  let(:wrong_link) { create(:link, :wrong_link, linkable: question) }

  it 'must be true if link from gists.github' do
    expect(link.gist?).to eq true
  end

  it 'must be FALSE if link from gists.github' do
    expect(wrong_link.gist?).to eq false
  end
end
