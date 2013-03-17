Plugin = require '../plugin'

class alwaysTrue extends Plugin

    runOnTrue: true

    run: (callSid, request, response) =>
        # this function will stop execution
        getcode = @getSourcePlugin('getCode')

        unless getcode.retrieveData(callSid, request, response)
            return

        # otherwise return stuff
        returnObj = {}
        returnObj.outcome = true

        returnObj


module.exports = alwaysTrue