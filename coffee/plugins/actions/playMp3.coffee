Twilio = require 'twilio'
Plugin = require '../plugin'

class playMp3 extends Plugin

    runOnTrue: true

    run: (callSid, request, response, decision) ->

        # play dial tonez
        twiml = new Twilio.TwimlResponse()
        twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50
        response.send twiml.toString()


module.exports = playMp3