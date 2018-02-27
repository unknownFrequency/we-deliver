App.messages = App.cable.subscriptions.create "MessagesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    roomId = $("#chat-box").data("room-id")
    @checkIn(roomId)

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel

    roomId = $("#chat-box").data("room-id")
    posts = $(".message-row").length
    if posts = 50
      $(".message-row").first().remove()

    $("#chat-box").append(data)
    $("#message-field").val("")

    notificationBar = $("#notification-bar")
    notificationBar.val("Ny besked i rum " + roomId)

    new Ajax.Request('/notifications', {
      method: 'post',
      parameters: {
        room_id: roomId,
      }
    });

    console.log(roomId)


  checkIn: (roomId) ->
    if roomId
      @perform "checkIn", room_id: roomId
    else
      @perform "checkOut"