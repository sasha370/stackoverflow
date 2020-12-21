require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should belong_to :linkable }
  it { should allow_value('http://www.google.com').for(:url) }
  it { should_not allow_value("Inv4lid_").for(:url) }
end
