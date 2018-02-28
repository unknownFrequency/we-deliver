class RoomController < ApplicationController
  def index
    @rooms = Room.all
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
    else
      if current_user
        room = Room.where(user_id: current_user.id).first
        redirect_to room_path(room)
      else
        redirect_to root_path
      end
    end

      # if user_signed_in? && current_user.admin && !notifications.nil? 
      #   if notifications 
      #     @notifications = Message.where(read: :false)
      #   end

          # notifications.each do |unreadMsg|
          #   if unreadMsg.room_id == current_room.id
          #     unreadMsg.read = true
          #     unreadMsg.save!
          #     redirect_back fallback_location: root_path
          #   end
          # end$
        # if notifications.kind_of(Array)
        # end
      # end
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
