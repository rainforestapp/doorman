# Define app and get require
express = require 'express'

# Retrieve Twilio object by requiring
Twilio = require 'twilio'
Twiml = Twilio.TwimlClient

# Instantiate a Twilio client object
client = new Twilio.RestClient 'AC1ce0d8d7a79de22f4c27bed657e8e810', '20f65a9da68ec4630c9c43d19baef94e', 'dumbo'


# Load Express
app = express()

# Setup first route
app.get '/', (request, response) =>
  response.send 'Hello World'

# Listen to Twilio
app.post "/respondToVoiceCall", (request, response) ->
  
  console.log request

  # Validate that this request really came from Twilio...
  if Twilio.validateExpressRequest(request,'20f65a9da68ec4630c9c43d19baef94e')
    twiml = new Twilio.TwimlResponse()
    twiml.say("Hi!  Thanks for checking out my app!")
    response.type "text/xml"
    response.send twiml.toString()
  else
    response.send "you are not twilio.  Buzz off."








# bind and listen for connection
app.listen process.env.PORT || 5000
console.log 'listening on port erm...'