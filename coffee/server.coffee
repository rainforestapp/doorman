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


saveParameters = (request) ->
    # if request.query?


# check plugins
checkDecisionPlugins = (callSid, request, response) =>

    decisionPlugin = {}

    # loop over each plugin and run it
    for decisionPlugin, i in config.plugins.decisions
        decisionPlugin = decisionPlugin.run(callSid, request, response)

        # if the plugin returns true, stop the loop to call actions
        break if decisionPlugin.outcome = true

    # call actions with the relevant response
    actions(callSid, decisionPlugin, request, response)


# action
actions = (callSid, decision, request, response) =>

    console.log 'actions hit'

    response.type "text/xml"

    # loop over actions
    for actionPlugin in config.plugins.actions

        if decision.outcome is true and actionPlugin.runOnTrue is true
            actionPlugin.run(callSid, request, response)

        else if decision.outcome is false and actionPlugin.runOnFalse is true
            actionPlugin.run(callSid, request, response)

    response.end()


saveRedisData = (hash, data) =>

    # get call id


# Listen to Twilio
app.post "/respondToVoiceCall", (request, response) =>

    # save call ID
    callSid = request.body.CallSid

    console.log 'Call -', callSid

    # save the parameters sent in
    saveParameters(request)

    # Validate that this request really came from Twilio...
    if @twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
        checkDecisionPlugins(callSid, request, response)

    else
        response.send "you are not twilio.  Buzz off."


# bind and listen for connection
app.listen process.env.PORT || 5000

