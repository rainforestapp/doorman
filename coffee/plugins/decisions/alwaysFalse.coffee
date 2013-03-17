Plugin = require '../plugin'

class alwaysFalse extends Plugin

    runOnTrue: true

    run: (callSid, request, response) =>

        console.log 'always false called!'

        # this function will stop execution
        # getcode = @getSourcePlugin('getCode')

        return false


module.exports = alwaysFalse