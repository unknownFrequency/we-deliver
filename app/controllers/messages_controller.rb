class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    @message.room = current_room

    @message.save
    redirect_back fallback_location: root_path
  end


  private

  def message_params
    params.require(:message).permit(:body)
  end
end
