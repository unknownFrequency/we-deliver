class RoomController < ApplicationController

  def index

  end

  def new
  end

  def create
  end

  def show
    set_current_room
    @message = Message.new
    @messages = @room.messages if @room && @room.messages

    if current_user.admin && notifications
      notifications.each do |unreadMsg|
        if unreadMsg.room_id == current_room.id
          unreadMsg.read = true
          unreadMsg.save!
        end
      end
    end
  end

  private

  def set_current_room
    if params[:id]
      @room = Room.find(params[:id])
    else
      @room = current_user.room
    end

    session[:current_room] = @room.id if @room
  end

  def order_params
    params.require(:room).permit(:user_id, :name) 
  end
end
