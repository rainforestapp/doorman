Plugin = require '../plugin'

class alwaysTrue extends Plugin

    runOnTrue: true

    run: (callSid, request, response) ->

        console.log "alwaysTrue #{callSid}"

        returnObj = {}
        returnObj.outcome = true

        returnObj


module.exports = alwaysTrue