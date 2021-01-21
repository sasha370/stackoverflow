require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service) { double('NotificationService') }
  let(:answer) { double('Answer') }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls NotificationService#send_notifications' do
    expect(service).to receive(:send_notifications).with(answer)
    NotificationJob.perform_now(answer)
  end
end
