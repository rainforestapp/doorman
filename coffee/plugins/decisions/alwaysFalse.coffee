Plugin = require '../plugin'

class alwaysFalse extends Plugin

    run: (callSid, request, response) =>

        return false


module.exports = alwaysFalse