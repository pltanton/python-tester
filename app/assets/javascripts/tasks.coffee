id = 0
edit = undefined

# Saves new test to local object and drows it on page
saveTest = ->
  input = $('#in')
  output = $('#out')
  if edit == undefined
    # Generate row and insert into table
    tr = """
    <tr class='test-instance'>
      <td>#{input.val()}</td>
      <td>#{output.val()}</td>
      <td><i class='material-icons'>mode_edit</i></td>
      <td><i class='material-icons'>delete</i></td>
    </tr>
    """
    jtr = $(tr).appendTo('#test-table tbody')
    # If card was hidden it should be shown now
    card = $('#test-card')
    card.fadeIn() unless $('#test-card').is(':visible')
    # Set onclick event on delete icon
    buttons = $(jtr).children().children 'i'
    buttons.eq(0).click editTest
    buttons.eq(1).click removeTest
  else
    edit[0].text input.val()
    edit[1].text output.val()
    edit = undefined

  # And finally clear text fields and close modal window
  $('#modal-new-test').closeModal()
  input.val ''
  output.val ''


# Removes row with test from DOM and from tests array
removeTest = (e) ->
  e.stopPropagation()
  e.stopImmediatePropagation()
  row = e.target.parentNode.parentNode
  row.parentNode.removeChild row
  if $('.test-instance').length == 0
    $('#test-card').fadeOut()

# Opens modal window to edit the test
editTest = (e) ->
  e.stopPropagation()
  e.stopImmediatePropagation()
  row = $(e.target.parentNode.parentNode)
  cells = row.children 'td'
  input_td = cells.eq(0)
  output_td = cells.eq(1)
  edit = [input_td, output_td]
  $('#in').val input_td.text()
  $('#out').val output_td.text()
  $('#modal-new-test').openModal()

# Adds extra fields to form and submiting it
saveTask = ->
  form = $('form')

  tests = []
  $('.test-instance').each (i) ->
    children = $(this).children 'td'
    tests.push
      in: children.eq(0).text()
      out: children.eq(1).text()
      index: this.dataset.index

  $('<input />').attr('type', 'hidden')
                .attr('name', 'tests')
                .attr('value', JSON.stringify tests).appendTo form
  form.submit()

class App.Tasks extends App.Base
  edit: =>
    $('.edit-test').each (i) -> $(this).click editTest
    $('.delete-test').each (i) -> $(this).click removeTest
    $('#submit-new-task').click -> saveTest()
    $('#submit-new-task-button').click -> saveTask()

  new: =>
    $('#submit-new-task').click -> saveTest()
    $('#submit-new-task-button').click -> saveTask()
