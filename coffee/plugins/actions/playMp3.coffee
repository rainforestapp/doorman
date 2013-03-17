Twilio = require 'twilio'

playMp3 = {}
playMp3.runOnTrue = true

playMp3.run = (request, response) =>

    console.log 'playing mp3'

    twiml = new Twilio.TwimlResponse()
    twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50
    console.log twiml.toString()
    response.write twiml.toString()


module.exports = playMp3