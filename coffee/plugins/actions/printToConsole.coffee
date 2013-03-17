# Print console output
printToConsole = {}
printToConsole.runOnTrue = false

printToConsole.run = (request, twiml) ->
    console.log 'running print to console'

module.exports = printToConsole