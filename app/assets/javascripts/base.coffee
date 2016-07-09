class App.Base

  constructor: ->
    if (window.jQuery) then RailsScript.setClearEventHandlers() # clearing application event handlers only possible with jQuery
    if notice != ''
      Materialize.toast notice, 2500
    if notice_alert != ''
      Materialize.toast notice-alert, 2500, 'red'
    $.ajaxSetup
      headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')}
    $('textarea').each -> $(this).trigger('autoresize')
    Materialize.updateTextFields()
    $('.material-tooltip:visible').each -> $(this).remove()
    $('.tooltipped').each -> $(this).tooltip {delay: 50}
    return this


  ###
  Run the new action for the create action.  Generally the create action will 'render :new' if there was a problem.
  This prevents doubling the code for each action.
  ###
  create: ->
    if typeof $this.new == 'function'
      return $this.new()


  ###
  Run the edit action for the update action.  Generally the update action will 'render :edit' if there was a problem.
  This prevents doubling the code for each action.
  ###
  update: ->
    if typeof $this.edit == 'function'
      return $this.edit()
