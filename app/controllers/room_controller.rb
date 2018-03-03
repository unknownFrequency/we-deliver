class RoomController < ApplicationController
  def index
    @rooms = Room.all.order(created_at: :desc)

  end

  def new
  end

  def create
  end

  def show
    set_current_room

    if current_user && (@room.user_id == current_user.id || current_user.admin)
      @message = Message.new
      @messages = @room.messages if @room && @room.messages

      unless notifications.empty?
        notifications.each do |unreadMsg|
          if unreadMsg.room_id == current_room.id && current_user.admin
            unreadMsg.read = true
            unreadMsg.save!
            # redirect_back fallback_location: root_path
          end
        end
      end
    elsif user_signed_in?
      room = Room.where(user_id: current_user.id).first
      redirect_to room_path(room)
    else
      redirect_to root_path
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
