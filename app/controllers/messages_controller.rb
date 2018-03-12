class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    @message.read = true if isAdmin?
    @message.room = current_room
    @message.save!
  end

  private

  def message_params
    params.require(:message).permit(:body, :read)
  end
end
