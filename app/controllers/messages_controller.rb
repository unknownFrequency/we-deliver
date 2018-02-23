class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    @message.room = current_room

    @message.save
    redirect_to room_path(current_room)
  end


  private

  def message_params
    params.require(:message).permit(:body)
  end
end
