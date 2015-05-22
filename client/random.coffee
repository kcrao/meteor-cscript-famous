#idxRandomImage = Math.floor(Math.round(2 * Math.random()))
#
window.populateArray = (gameRound) ->

  console.log '_____brain_buster.dbg_____'
  matchCount = 0

  #   for (i=0; i<20; i++) {
  while matchCount < 20 # paramterized
    if i > 0
      Chunk = Math.floor(Math.round(10 * Math.random()))
      # %50 chance num 0 or 1
      # if chunk =3 then there is a 40% chance of repeating for numbers 0-10
      if Chunk <= 5
        gameRound[i] = gameRound[i - 1]
        # console.log( "{",Chunk,"}," , gameRound[i] );
      else
        gameRound[i] = Math.floor(Math.round(3 * Math.random()))
    else
      gameRound[i] = Math.floor(Math.round(3 * Math.random()))
    dbgString = 'Round[' + i + '] ' + gameRound[i]
    if gameRound[i] == gameRound[i - 2]
      # console.log ("So far you have " +matchCount + "matches");
      # console.log ("You have a match for the value " + gameRound[i] +'at' +i );
      dbgString = dbgString + ', M{' + matchCount + '}'
      matchCount++
    console.log dbgString
    # console.log ("\n");
    i++
  n = gameRound.length
  console.log '_____brain_buster.dbg_____'
  console.log 'You needed an array sized at ' + n


console.log 'devWidth := ' + devWidth
devWidth = (devWidth - 185) / 2
console.log 'devWidth := ' + devWidth
Session.set 'currenImageId', 'http://upload.wikimedia.org/wikipedia/tr/e/ed/Bart_Simpson.svg'
Session.set 'deviceWidth', devWidth
console.log 'deviceWidthsession' + Session.get('deviceWidth')
totalIntervals = 0
#gameRound = new Array
i = 0
matchCounter = 0
dbgString = ''
