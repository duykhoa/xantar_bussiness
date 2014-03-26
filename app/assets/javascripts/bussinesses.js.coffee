# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $('#query-text-field').autocomplete
    source: (request, response) ->
      results = $.ui.autocomplete.filter($('#tags').data('category'), request.term)
      response(results.slice(0, 10))
  $('#place-text-field').autocomplete
    source: (request, response) ->
      results = $.ui.autocomplete.filter($('#tags').data('place'), request.term)
      response(results.slice(0, 10))
  $('#results-container').simplePagination
     items_per_page: 10
     number_of_visible_page_numbers: 10
