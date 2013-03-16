# Define app and get require
express = require 'express'
Twilio = require 'twilio'

# Require config
config = require './config'

# Instantiate a Twilio client object
client = new Twilio.RestClient 'AC1ce0d8d7a79de22f4c27bed657e8e810', '20f65a9da68ec4630c9c43d19baef94e'

# Load Express
app = express()

# Middleware to parse the post properly (express newbs)
app.use express.bodyParser()

# Setup first route
app.get '/', (request, response) ->
    response.send 'Hello World'

# Listen to Twilio
app.post "/respondToVoiceCall", (request, response) =>

    console.log request.body
    
    # Validate that this request really came from Twilio...
    if Twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
        checkDecisionPlugins(request, response)

    else
        response.send "you are not twilio.  Buzz off."


# check plugins
checkDecisionPlugins = (request, response) =>

    decisionPlugin = {}

    # loop over each plugin and run it
    for decisionPlugin, i in config.plugins.decisions
        decisionPlugin = decisionPlugin.run()

        # if the plugin returns true, stop the loop to call actions
        break if decisionPlugin.outcome = true

    # call actions with the relevant response
    actions(decisionPlugin, request, response)


# action
actions = (decision, request, response) =>

    response.type "text/xml"

    # loop over actions
    for actionPlugin in config.plugins.actions

        if decision.outcome is true and actionPlugin.runOnTrue is true 
            actionPlugin.run()

        else if decision.outcome is false and actionPlugin.runOnFalse is true
            actionPlugin.run()

# checkDecisionPlugins()

# bind and listen for connection
app.listen process.env.PORT || 5000