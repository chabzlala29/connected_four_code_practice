@BoardGame ||= {}

jQuery.extend @BoardGame,
  init: ->
    BoardGame.setColorInfo('black')
    BoardGame.setChipHolderEvent()

  counter: 0

  initResetEvent: ($element) ->
    $element.click (e) ->
      e.preventDefault()
      BoardGame.reset()

  setChipHolderEvent: ->
    $('.chip-holder').click (e) ->
      if BoardGame.checkIfClickable(@)
        color = if BoardGame.counter%2 == 0
                  'red'
                else
                  'black'

        BoardGame.checkIfDraw()
        BoardGame.setColorInfo(color)
        BoardGame.counter++

        $(@).addClass('filled')
        $(@).addClass(color)
        BoardGame.checkIfConnected()
  
  setColorInfo: (color) ->
    if color == 'red'
      $('.info').html("<span>It's BLACK's turn!</span>")
    else
      $('.info').html("<span style='color: red'>It's RED's turn!</span>")

  setElementVars: ($element) ->
    row_id = $element.parent('.row').attr('id')
    { 
      id: $element.attr('id')
      row_id: row_id
      charcode: row_id.charCodeAt()
    }

  checkIfDraw: ->
    if $('.filled').length == 42
      alert("It's a Draw!")
      BoardGame.reset()
  checkIfClickable: (element) ->
    $element = $(element)
    vars = BoardGame.setElementVars($element)
    return false if $element.hasClass('filled')

    return true if vars.charcode == 102
    $belowElem = $("div.row##{String.fromCharCode(vars.charcode + 1)}").find(".chip-holder##{vars.id}")
    $belowElem.hasClass('filled')

  checkIfConnected: ->
    $('.filled').each (index, element) ->
      $element = $(element)
      vars = BoardGame.setElementVars($element)

      BoardGame.checkHorizontally(vars, $element)
      BoardGame.checkVertically(vars, $element)
      BoardGame.checkDiagonally(vars, $element)

  checkHorizontally: (vars, $element) ->
    $row = $(".row##{vars.row_id}")
    id = parseInt(vars.id)

    currentColor = BoardGame.getCurrentColor($element)

    loopArr = (isAdd=false) ->
      current_id = id
      arr = []
      for [1..3]
        if isAdd
          current_id += 1
        else
          current_id -= 1
        arr.push $row.find(".chip-holder##{current_id}").hasClass("filled #{currentColor}")
      BoardGame.alertWinner(currentColor, arr)
    # right
    loopArr(true)

    #left
    loopArr()

  checkVertically: (vars, $element) ->
    $row = $(".row##{vars.row_id}")

    currentColor = BoardGame.getCurrentColor($element)

    loopArr = (isAdd=false) ->
      current_row = vars.charcode
      arr = []
      for [1..3]
        if isAdd
          current_row += 1
        else
          current_row -= 1
        try
          arr.push $(".row##{String.fromCharCode(current_row)}").find(".chip-holder##{vars.id}").hasClass("filled #{currentColor}")
        catch e then true

      BoardGame.alertWinner(currentColor, arr)

    # down
    loopArr(true)

    # up
    loopArr()

  checkDiagonally: (vars, $element) ->
    $row = $(".row##{vars.row_id}")
    id = parseInt(vars.id)

    currentColor = BoardGame.getCurrentColor($element)

    loopArr = (isAddRow, isAddId) ->
      current_row = vars.charcode
      current_id = id
      arr = []
      for [1..3]
        if isAddRow
          current_row += 1
        else
          current_row -= 1

        if isAddId
          current_id += 1
        else
          current_id -= 1

        try
          arr.push $(".row##{String.fromCharCode(current_row)}").find(".chip-holder##{current_id}").hasClass("filled #{currentColor}")
        catch e then true

      BoardGame.alertWinner(currentColor, arr)

    # upper left
    loopArr(false, false)
    
    # upper right
    loopArr(false, true)

    # lower left
    loopArr(true, false)

    # lower right
    loopArr(true, true)

  alertWinner: (color, arr) ->
    if((arr.filter (r) -> r == true).length == 3)
      $('.info').html "<span style='color: #{color}'>Winner is #{color.toUpperCase()}!</span>"
      BoardGame.reset()

  reset: ->
    $('.filled').removeClass('filled red black')
    BoardGame.counter = 0

  getCurrentColor: ($element) ->
    return 'red' if $element.hasClass('red')
    return 'black' if $element.hasClass('black')
