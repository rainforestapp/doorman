# Plugin class

class Plugin
    constructor: (path) ->
        crypto = require('crypto')
        @hash = crypto.createHash('md5').update(path).digest("hex")


    run: ->


    # try to retrieve own data from redis
    retrieveData: (callSid, request, response) =>

        # try to get the data
        global.redis.hget callSid, @hash, (err, redisResponse) =>
            unless err
                if redisResponse?
                    return obj = JSON.parse redisResponse
                else
                    run(callSid, request, response)


    getSourcePlugin: (name) ->

        theSource = false
        for source in global.config.plugins.sources
            if source.__proto__.constructor.name == name
                theSource = source
                break

        theSource


    getHasRun: (callSid, callback) ->
        global.redis.hget callSid + '-plugins-hasrun', @hash, (err, response) =>
            console.log 'theres a callback', response?
            callback(response?)


    setHasRun: (callSid) =>
        global.redis.hset callSid + '-plugins-hasrun', @hash, true, (err, response) =>
            return response



module.exports = Plugin