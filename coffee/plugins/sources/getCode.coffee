Twilio = require 'twilio'
Plugin = require '../plugin'

class getCode extends Plugin

    runOnTrue: true

    run: (callSid, request, response, expected) =>

        # if the data is there already and equals what is expected, just return it
        if global.data[callSid][@hash]?.data?.Digits? is true and global.data[callSid][@hash].data.Digits is expected
            return global.data[callSid][@hash].data.Digits

        # otherwise request from twilio like a gangster
        else

            url = String("/respondToVoiceCall?pluginHash=" + @hash)

            twiml = new Twilio.TwimlResponse()
            twiml.gather numDigits: 4, action: url, () ->
                twiml.say 'Please enter 4 digits:'

            response.send twiml.toString()

            global.dieNow = true


module.exports = getCode