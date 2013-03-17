Plugin = require '../plugin'

class alwaysTrue extends Plugin

    runOnTrue: true

    run: (callSid, request, response) =>

        console.log 'always true called!'

        # this function will stop execution
        # getcode = @getSourcePlugin('getCode')

        return true


module.exports = alwaysTrue