# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("form[data-update-target]").bind "ajax:success", (evt, data) ->
    target = $(this).data("update-target")
    $("#" + target).prepend data
    $('#content').val('')
