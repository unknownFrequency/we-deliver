class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "messages_room_#{message.room_id}", render_message(message)
  end

  private

  def render_message(message)
    ApplicationController.renderer.render partial: "shared/message", object: message
  end
end
