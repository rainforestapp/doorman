# Define app and get require
express = require 'express'
twilio = require 'twilio'

# Require config
config = require './config'

# Load Express
global.app = app = express()

# main program body that depends on Redis connection
main = ->

    # Middleware to parse the post properly (express newbs)
    app.use express.bodyParser()


    saveParameters = (callSid, request) ->

        # if there is a plugin hash present in the body
        if request.query.pluginHash?

            # get the hash
            hash = request.query.pluginHash

            # save in global data object so other functions have access
            global.data[callSid][hash] = {} unless global.data[callSid][hash]?
            global.data[callSid][hash].data = request.body

            # stringify entire plugin shit to save
            obj = JSON.stringify({ hasRun: global.data[callSid][hash].hasRun?, data: request.body })

            # save params to redis because redis sux
            global.redis.hset callSid, request.query.pluginHash, obj, (err, obj) ->


    # check plugins
    checkDecisionPlugins = (callSid, request, response) ->

        state = false

        # iterate over all decision plugins
        for decisionPlugin in global.config.plugins.decisions

            # execute if it has not already been run
            unless global.data[callSid][decisionPlugin.hash]?.hasRun?
                
                # run the decision plugin and pass the result into 'state'
                state = decisionPlugin.run(callSid, request, response)

                if global.dieNow
                    break

                # save that it has been run
                # ...locally
                global.data[callSid][decisionPlugin.hash] = {} unless global.data[callSid][decisionPlugin.hash]?
                global.data[callSid][decisionPlugin.hash].hasRun = true

                # ...to redis
                global.redis.hset callSid, decisionPlugin.hash, JSON.stringify(global.data[callSid][decisionPlugin.hash])

                break if state is true

        actions(callSid, request, response, state) unless global.dieNow


    # action
    actions = (callSid, request, response, decision) =>

        # iterate over all action plugins
        for actionPlugin in global.config.plugins.actions

            if actionPlugin.runOnTrue is true and decision is true or actionPlugin.runOnFalse is true and decision is false

                # execute if it has not already been run
                unless global.data[callSid][actionPlugin.hash]?.hasRun?
                    actionPlugin.run(callSid, request, response, decision)

                    # save that it has been run
                    # ...locally
                    global.data[callSid][actionPlugin.hash] = {} unless global.data[callSid][actionPlugin.hash]?
                    global.data[callSid][actionPlugin.hash].hasRun = true

                    # ...to redis
                    global.redis.hset callSid, actionPlugin.hash, JSON.stringify(global.data[callSid][actionPlugin.hash])



    # Listen to Twilio
    app.post "/respondToVoiceCall", (request, response) ->

        console.log 'THIS IS A NEW POST'

        # save call sid
        callSid = request.body.CallSid

        # helperz
        global.dieNow = false
        global.data[callSid] = {} unless global.data[callSid]?

        # get all plugin shit
        global.redis.hgetall callSid, (err, obj) ->

            if obj
                # if theres anything in redis, iterate over all plugins and save it in globez
                for key, val of obj
                    global.data[callSid][key] = JSON.parse val
    
            # save the parameters sent in
            saveParameters(callSid, request)

            # Validate that this request really came from Twilio...
            if twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
                checkDecisionPlugins(callSid, request, response)

            else
                response.send "you are not twilio. Buzz off."



###############################
### REDIZZZZZ
###############################
if process.env.REDISTOGO_URL
    rtg   = require("url").parse process.env.REDISTOGO_URL
    redis = require("redis").createClient rtg.port, rtg.hostname
    redis.auth rtg.auth.split(":")[1]
else
    redis = require("redis").createClient()

# setup global data object
global.data = {} unless global.data?

# set redis to always be global
global.redis = redis

# error logging
global.redis.on "error", (err) ->
    console.log "Error " + err

# started helper
global.redis.on "connect", ->
    global.redis.incr 'started'
    global.redis.get 'started', (err, response) ->
        unless err
            console.log 'Started', response, 'times'

    main()


# bind and listen for connection
app.listen process.env.PORT || 5000

