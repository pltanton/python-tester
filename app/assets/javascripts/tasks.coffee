id = 0
tests = []
# Saves new test to local object and drows it on page
submitNewTask = ->
  # Find and append to test array new pair of data
  test =
    in: $('#in').val()
    out: $('#out').val()
    id: id
  tests.push test
  # Generate row and insert into table
  tr = """
  <tr data-index='#{id}'>
    <td>#{test.in}</td>
    <td>#{test.out}</td>
    <td><i class='material-icons'>delete</i></td>
  </tr>
  """
  id++
  jtr = $('#test-table tbody').append tr
  # If card was hidden it should be shown now
  card = $('#test-card')
  unless $('#test-card').is(':visible')
    card.fadeIn()
  # Set onclick event on delete icon
  $('i', jtr).click removeTest
  # And finally clear text fields and close modal window
  $('#modal-new-test').closeModal()
  $('#in').val('')
  $('#out').val('')


# Removes row with test from DOM and from tests array
removeTest = (e) ->
  e.stopPropagation()
  e.stopImmediatePropagation()
  row = e.target.parentNode.parentNode
  tests.splice(parseInt(row.dataset.index), 1)
  row.parentNode.removeChild row
  if tests.length == 0
    $('#test-card').fadeOut()


class App.Tasks extends App.Base
  edit: =>
    $('#submit-new-task').click -> submitNewTask()

  new: =>
    $('#submit-new-task').click -> submitNewTask()
