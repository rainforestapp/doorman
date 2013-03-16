# Define app and get require
express = require 'express'

# Retrieve Twilio object by requiring
Twilio = require 'twilio'

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
app.post "/respondToVoiceCall", (request, response) ->

    # Validate that this request really came from Twilio...
    if Twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
        twiml = new Twilio.TwimlResponse()
        twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50
        response.type "text/xml"
        response.send twiml.toString()
    else
        response.send "you are not twilio.  Buzz off."

# bind and listen for connection
app.listen process.env.PORT || 5000