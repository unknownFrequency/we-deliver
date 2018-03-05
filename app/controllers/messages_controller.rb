class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    @message.room = current_room

    if @message.save
      respond_to do |format|
        # format.html { redirect_back fallback_location: root_path }
        format.js {
          ActionCable.server.broadcast "messages_room_#{current_room.id}",
          render_to_string(partial: 'shared/message', object: @message)
        }
      end
    end
  end


  private

  def message_params
    params.require(:message).permit(:body)
  end
end
