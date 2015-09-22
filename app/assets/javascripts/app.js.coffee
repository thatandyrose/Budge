do quickSum = ->
  
  init = ->

    $('input.quick-sum-checkbox').on 'click', ->
      total = 0
      
      $('input.quick-sum-checkbox:checked').each ->
        cbox = $(this)
        total += parseFloat cbox.val()

      $('#quick-sum').html total

  $(document).ready -> init()  

  return {

  }