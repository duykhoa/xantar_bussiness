$(document).ready ->
  $('#vote-up').on 'click',  ->
    factual_id = $(this).data('factual-id')
    query = $(this).data('query')
    place = $(this).data('place')
    factual_url = '/promote'
    $this = $(this)
    $.ajax
      url: factual_url
      type: 'POST'
      data: {promotion: {factual_id: factual_id, query: query, place: place}}
      success: (data, status, response) ->
        if data.status == true
          $this.text(parseInt($this.html()) + 1)
        $this.addClass('disabled')
