class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_file

  authorize_resource

  def destroy
    @file.purge
  end

  private

  def set_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
