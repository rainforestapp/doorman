Plugin = require '../plugin'

class alwaysTrue extends Plugin

    runOnTrue: true

    run: (callSid, request, response) ->

        returnObj = {}
        returnObj.outcome = true

        returnObj


module.exports = alwaysTrue