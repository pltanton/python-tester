App.cable.initSubmisisons = ->
  App.submissions = App.cable.subscriptions.create "SubmissionsChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      console.log 'Disconnected'
      # Called when the subscription has been terminated by the server

    received: (data) ->
      console.log 'recived'
      tr = $($.parseHTML(data)).hide()
      subm = $("[data-submission-id='#{tr.data().submissionId}']")
      if subm.length == 1
        subm.fadeOut().replaceWith(tr).fadeIn()
      else
        tr.prependTo('#submissions').fadeIn()
      $('.tooltipped').tooltip {delay: 50}
      # Called when there's incoming data on the websocket for this channel
