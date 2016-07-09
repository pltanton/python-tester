saveContest = ->
  form = $('form')

  selected = $('.collection [type="checkbox"]:checked').map () ->
    $(this).data().taskId

  $('<input />').attr('type', 'hidden')
                .attr('name', 'selected_tasks')
                .attr('value', JSON.stringify(selected.toArray())).appendTo form
  form.submit()

class App.Contests extends App.Base
  new: =>
    $('#submit-new-contest-button').click -> saveContest()


  edit: =>
    $('#submit-new-contest-button').click -> saveContest()

  show: =>
    App.initSubmissionsLinks()
