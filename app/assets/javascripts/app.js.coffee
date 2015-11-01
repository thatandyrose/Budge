do toggler = ->

  init = ->
    $('a[data-toggle]').on 'click', (e) ->
      e.preventDefault()
      $($(this).data('toggle')).toggle()

  $(document).ready -> init()
  $(document).on 'ajaxSuccess', -> init()

  return {

  }

do categorySelect = ->
  
  init = ->
    $('.select-category').on 'change', ->
      $(this).closest('form').submit();

  $(document).ready -> init()
  $(document).on 'ajaxSuccess', -> init()

  return {

  }

do quickSum = ->
  
  init = ->

    $('input.quick-sum-checkbox').on 'click', ->
      total = 0
      
      $('input.quick-sum-checkbox:checked').each ->
        cbox = $(this)
        total += parseFloat cbox.val()

      $('#quick-sum').html total

  $(document).ready -> init()
  $(document).on 'ajaxSuccess', -> init() 

  return {

  }