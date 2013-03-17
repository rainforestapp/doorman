# Define app and get require
@express = require 'express'
@twilio = require 'twilio'


# Require config
config = require './config'


# Redis
if process.env.REDISTOGO_URL
    rtg   = require("url").parse process.env.REDISTOGO_URL
    redis = require("redis").createClient rtg.port, rtg.hostname
    redis.auth rtg.auth.split(":")[1]
else
    redis = require("redis").createClient()



redis.on "error", (err) =>
    console.log "Error " + err

redis.on "connect", =>
    redis.incr 'started'
    redis.get 'started', (err, response) ->
        unless err
            console.log 'Started', response, 'times'


# Load Express
app = @express()

# Middleware to parse the post properly (express newbs)
app.use @express.bodyParser()

# Setup first route
app.get '/', (request, response) ->
    response.send 'Hello World'


saveParameters = (callSid, request) ->
    if request.query.pluginHash?
        redis.hset callSid, request.query.pluginHash, JSON.stringify(request.body), (err, response) =>
            console.log 'set to redis:', callSid, request.query.pluginHash, response


getParameters: (callSid, pluginHash) ->
    console.log  'getting stuff', callSid, pluginHash
    redis.hget callSid, pluginHash, (err, response) ->
        console.log 'got from redis:', callSid, pluginHash, response
        response


# check plugins
checkDecisionPlugins = (callSid, request, response) =>

    decisionPlugin = {}

    # loop over each plugin and run it
    for decisionPlugin in config.plugins.decisions
        console.log decisionPlugin

        decision = decisionPlugin.run(callSid, request, response)

        # if the plugin returns true, stop the loop to call actions
        break if decision.outcome = true

    # call actions with the relevant response
    actions(callSid, decision, request, response)


# action
actions = (callSid, decision, request, response) =>

    response.type "text/xml"

    # loop over actions
    for actionPlugin in config.plugins.actions

        console.log actionPlugin

        if decision.outcome is true and actionPlugin.runOnTrue is true
            actionPlugin.run(callSid, request, response)

        else if decision.outcome is false and actionPlugin.runOnFalse is true
            actionPlugin.run(callSid, request, response)





# Listen to Twilio
app.post "/respondToVoiceCall", (request, response) =>

    # save call sid
    callSid = request.body.CallSid

    # save the parameters sent in
    saveParameters(callSid, request)

    # Validate that this request really came from Twilio...
    if @twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
        checkDecisionPlugins(callSid, request, response)

    else
        response.send "you are not twilio. Buzz off."


# bind and listen for connection
app.listen process.env.PORT || 5000

