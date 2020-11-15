class CommentsChannel < ApplicationCable::Channel
  def subscribed
    resource = GlobalID::Locator.locate(params[:id])
    stream_for resource
  end
end
