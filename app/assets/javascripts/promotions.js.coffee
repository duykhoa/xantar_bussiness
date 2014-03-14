$(document).ready ->
  $('#vote-up').on 'click',  ->
    factual_id = $(this).data('factual-id')
    query = $(this).data('query')
    factual_url = '/promote'
    $this = $(this)
    $.ajax
      url: factual_url
      type: 'POST'
      data: {promotion: {factual_id: factual_id, query: query}}
      success: (data, status, response) ->
        $this.css('display', 'none')
