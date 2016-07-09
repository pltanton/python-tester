# Fetched solution and opens modal with it
App.fetchSolution = (solutionId) ->
  $.getJSON "/submissions/#{solutionId}", (data) ->
    console.log data
    modal = $ '#code-modal'
    title = $ '#code-title'
    output = $ '#code-output'
    body = $ '#code-body'

    title.text data.title
    body.empty().append data.body
    output.empty().append data.output

    modal.openModal()

App.initSubmissionsLinks = ->
  $('.solution-cell').each (e) ->
    submissionId = $(this).data().submissionId
    console.log submissionId
    if submissionId != ''
      $(this).click () ->
        App.fetchSolution(submissionId)
