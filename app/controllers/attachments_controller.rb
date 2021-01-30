class AttachmentsController < ApplicationController
  skip_load_and_authorize_resource :only => :destroy

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file
    @file.record.touch
    @file.purge
  end
end
