App.messages = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    roomId = $("#chat-box").data("room-id")
    @checkIn(roomId)

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    roomId = $("#chat-box").data("room-id")
    activeRoom = $("[data-behavior='messages'][data-room-id='#{roomId}']")

    $("#chat-box").append(data+" "+datetime)
    $("#message-field").val("")

  checkIn: (roomId) ->
    if roomId
      @perform "checkIn", room_id: roomId
    else
      @perform "checkOut"

#//   posts = $(".message-row").length
#//   if posts > 50
#//     $(".message-row").first().remove()
#//if activeRoom.length > 0
#//    $("[data-behavior='room-link'][data-room-id='#{roomId}']").css("font-size", "200px")

