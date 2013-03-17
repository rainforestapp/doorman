Plugin = require '../plugin'

class alwaysTrue extends Plugin

    run: (callSid, request, response) =>
        return true

module.exports = alwaysTrue