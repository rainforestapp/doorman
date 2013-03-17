# Plugin class

class Plugin
    constructor: (path) ->
        crypto = require('crypto')
        @hash = crypto.createHash('md5').update(path).digest("hex")

    run: ->

module.exports = Plugin