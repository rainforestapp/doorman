Plugin = require '../plugin'

class alwaysFalse extends Plugin

    runOnTrue: true

    run: (callSid, request, response) =>

        console.log 'always false called!'

        # this function will stop execution
        getcode = @getSourcePlugin('getCode')
        digits = getcode.run(callSid, request, response, '1234')

        return digits is '1234'


module.exports = alwaysFalse