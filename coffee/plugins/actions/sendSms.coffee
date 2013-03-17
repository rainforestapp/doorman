Twilio = require 'twilio'

sendSms = {}
sendSms.runOnTrue = true
sendSms.runOnFalse = true

sendSms.run = (request, response) ->

    twiml = new Twilio.TwimlResponse()
    twiml.say "Hi, I'm cool!"
    console.log twiml.toString()
    response.write twiml.toString()


module.exports = sendSms