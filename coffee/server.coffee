# Define app and get require
@express = require 'express'
@twilio = require 'twilio'


# Require config
config = require './config'

# Load Express
app = @express()

# main program body that depends on Redis connection
main = =>

    # Middleware to parse the post properly (express newbs)
    app.use @express.bodyParser()

    # Setup first route
    app.get '/', (request, response) ->
        response.send 'Hello World'


    getParameters = (callSid, pluginHash) ->
        console.log  'getting stuff', callSid, pluginHash
        global.redis.hget callSid, pluginHash, (err, response) ->
            console.log 'got from redis:', callSid, pluginHash, response


    saveParameters = (callSid, request) ->
        # if there is a plugin hash present in the body
        if request.query.pluginHash?
            # stringify body
            obj = JSON.stringify(request.body)

            # save params to redis
            global.redis.hset callSid, request.query.pluginHash, obj , (err, response) =>
                console.log 'set to redis:', callSid, request.query.pluginHash, response
                getParameters(callSid, request.query.pluginHash)


    runPlugin = (callSid, request, response) =>

        # run the decision plugin
        decision = decisionPlugin.run(callSid, request, response)

        # save that this plugin has been run
        decisionPlugin.setHasRun()



    # check plugins
    checkDecisionPlugins = (callSid, request, response, i) =>

        i = 0 unless i

        unless i is config.plugins.decisions.length

            console.log 'checking decision plugin', i
            
            decisionPlugin = config.plugins.decisions[i]
                
            decisionPlugin.getHasRun callSid, (callbackResponse) =>
                if callbackResponse is false
                    console.log 'callback false', i
                    checkDecisionPlugins( callSid, request, response, i+1 ) 
                else
                    console.log 'callback response is true'
                    # call actions with the relevant response
                    actions(callSid, callbackResponse, request, response)

        else
            console.log 'the end of the decisionz!'
            actions(callSid, false, request, response)        


    # action
    actions = (callSid, decision, request, response) =>

    #    response.type "text/xml"

        console.log "we're at actions!"

        # loop over actions
        for actionPlugin in config.plugins.actions

            console.log actionPlugin

            # if decision.outcome is true and actionPlugin.runOnTrue is true
            #     actionPlugin.run(callSid, request, response)

            # else if decision.outcome is false and actionPlugin.runOnFalse is true
            #     actionPlugin.run(callSid, request, response)


    # Listen to Twilio
    app.post "/respondToVoiceCall", (request, response) =>

        console.log ''
        console.log '==============='
        console.log 'START NEW THING'
        console.log '==============='

        # save call sid
        callSid = request.body.CallSid

        # save the parameters sent in
        saveParameters(callSid, request)

        # Validate that this request really came from Twilio...
        if @twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
            checkDecisionPlugins(callSid, request, response)

        else
            response.send "you are not twilio. Buzz off."


# Redis
if process.env.REDISTOGO_URL
    rtg   = require("url").parse process.env.REDISTOGO_URL
    redis = require("redis").createClient rtg.port, rtg.hostname
    redis.auth rtg.auth.split(":")[1]
else
    redis = require("redis").createClient()

# set redis to always be global
global.redis = redis

# error logging
global.redis.on "error", (err) =>
    console.log "Error " + err

# started helper
global.redis.on "connect", =>
    global.redis.incr 'started'
    global.redis.get 'started', (err, response) ->
        unless err
            console.log 'Started', response, 'times'

    main()


# bind and listen for connection
app.listen process.env.PORT || 5000

