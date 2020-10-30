class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user&.author?(Object.const_get(@link.linkable_type).find @link.linkable_id)
  end
end
