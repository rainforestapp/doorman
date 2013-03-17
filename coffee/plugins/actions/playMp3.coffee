Twilio = require 'twilio'
Plugin = require '../plugin'

class playMp3 extends Plugin

    runOnTrue: true

    run: (callSid, request, response) ->

        console.log 'playing mp3 ---- should not see'

        twiml = new Twilio.TwimlResponse()
        twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50
        console.log twiml.toString()
        response.send twiml.toString()
        response.end()


module.exports = playMp3