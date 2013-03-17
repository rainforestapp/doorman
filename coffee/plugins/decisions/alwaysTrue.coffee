Plugin = require '../plugin'

class alwaysTrue extends Plugin

    runOnTrue: true

    run: (callSid, request, response) =>
        # this function will stop execution
        getcode = @getSourcePlugin('getCode')

        getcode.retrieveData callSid, request, response, (hasData) =>
            if hasData?
                # otherwise return stuff
                returnObj = {}
                returnObj.outcome = true
                return returnObj

            else
                return


module.exports = alwaysTrue