Plugin = require '../plugin'

class alwaysTrue extends Plugin

    runOnTrue: true

    run: (callSid, request, response) =>

        console.log 'always true called!'

        return false


module.exports = alwaysTrue