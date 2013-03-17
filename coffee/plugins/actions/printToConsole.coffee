Plugin = require '../plugin'

class printToConsole extends Plugin

    runOnTrue: true

    run: (callSid, request, response, decision) ->
        console.log 'hai! printinz'


module.exports = printToConsole