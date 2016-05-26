@BoardGame ||= {}

jQuery.extend @BoardGame,
  init: ->
    BoardGame.setChipHolderEvent()

  counter: 0

  setChipHolderEvent: ->
    # colors
    red = 'red'
    black = 'black'

    $('.chip-holder').click (e) ->
      if BoardGame.checkIfClickable(@)
        color = if BoardGame.counter%2 == 0
                  red
                else
                  black
        $(@).addClass('filled')
        $(@).addClass(color)
        BoardGame.checkIfConnected()
        BoardGame.counter++

  setElementVars: ($element) ->
    row_id = $element.parent('.row').attr('id')
    { 
      id: $element.attr('id')
      row_id: row_id
      charcode: row_id.charCodeAt()
    }

  checkIfClickable: (element) ->
    vars = BoardGame.setElementVars($(element))
    return true if vars.charcode == 102
    $belowElem = $("div.row##{String.fromCharCode(vars.charcode + 1)}").find(".chip-holder##{vars.id}")
    $belowElem.hasClass('filled')

  checkIfConnected: ->
    $('.filled').each (index, element) ->
      vars = BoardGame.setElementVars($(element))
      BoardGame.checkHorizontally(vars, $(element))
      BoardGame.checkVertically(vars, $(element))

  checkHorizontally: (vars, $element) ->
    $row = $(".row##{vars.row_id}")
    id = parseInt(vars.id)

    currentColor = if $element.hasClass('red')
                    'red'
                   else
                    'black'

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

    currentColor = if $element.hasClass('red')
                    'red'
                   else
                    'black'

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
  alertWinner: (color, arr) ->
    if((arr.filter (r) -> r == true).length == 3)
      alert "Winner is #{color}!"
      $('.filled').removeClass('filled red black')
