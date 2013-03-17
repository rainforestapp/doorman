Twilio = require 'twilio'

sendSms = {}
sendSms.runOnTrue = false
sendSms.runOnFalse = false

sendSms.run = (request, response) ->

    twiml = new Twilio.TwimlResponse()
    twiml.say "Hi, I'm cool!"
    console.log twiml.toString()
    response.write twiml.toString()


module.exports = sendSms