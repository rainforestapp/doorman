# Plugin class


class Plugin
    constructor: (path) ->
        crypto = require('crypto')
        @hash = crypto.createHash('md5').update(path).digest("hex")

    run: ->

    getSourcePlugin: (name) ->
        
        theSource = false
        for source in global.config.plugins.sources
            if source.__proto__.constructor.name == name
                theSource = source
                break

        theSource

module.exports = Plugin