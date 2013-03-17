Twilio = require 'twilio'
Plugin = require '../plugin'

class getCode extends Plugin

    runOnTrue: true

    run: (callSid, request, response) ->

        twiml = new Twilio.TwimlResponse()
        twiml.play('Please dish four numbers at me bro').gather("/respondToVoiceCall?pluginHash=" + @hash)
        response.send twiml.toString()


module.exports = getCode