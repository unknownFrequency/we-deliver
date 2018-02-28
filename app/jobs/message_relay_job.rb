class MessageRelayJob < ApplicationJob
  queue_as :default

  def perform(message, current_room)
        ActionCable.server.broadcast "messages_room_#{current_room.id}", {
          message: MessageController.render(message),
          chatroom_id: current_room.id
        }
    # respond_to do |format|
    #   format.html { redirect_back fallback_location: root_path }
    #   format.js {
    #     ActionCable.server.broadcast "messages_room_#{current_room.id}",
    #     render_to_string(partial: 'shared/message', object: message)
    #   }
    # end
  end
end
