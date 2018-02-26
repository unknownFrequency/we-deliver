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
    # @messages = current_room.messages if current_room
    @messages = @room.messages if @room && @room.messages
    @admin = User.where(admin: 1).first
    
  end

  private

  def set_current_room
    if params[:roomId]
      @room = Room.find_by(id: params[:roomId])
    else
      @room = current_user.room
    end

    session[:current_room] = @room.id if @room
  end

  def order_params
    params.require(:room).permit(:user_id, :name) 
  end
end
