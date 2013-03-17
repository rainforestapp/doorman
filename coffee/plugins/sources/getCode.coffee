Twilio = require 'twilio'

getCode = {}
getCode.runOnTrue = false

getCode.run = (request, response) =>

    console.log 'getting code from dude at the door'

    # twiml = new Twilio.TwimlResponse()
    # twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50
    # console.log twiml.toString()
    # response.write twiml.toString()


module.exports = getCode