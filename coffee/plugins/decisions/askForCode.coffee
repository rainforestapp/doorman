Plugin = require '../plugin'

class askForCode extends Plugin

    run: (callSid, request, response) =>

        # this function will stop execution
        getcode = @getSourcePlugin('getCode')
        digits = getcode.run(callSid, request, response, '1234')

        return digits is '1234'


module.exports = askForCode