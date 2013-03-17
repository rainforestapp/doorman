Twilio = require 'twilio'
Plugin = require '../plugin'

class getCode extends Plugin

    run: (callSid, request, response, expectedDigits) =>

        # if the data is there already and equals what is expectedDigits, just return it
        if global.data[callSid][@hash]?.data?.Digits? is true and global.data[callSid][@hash].data.Digits is expectedDigits
            return global.data[callSid][@hash].data.Digits

        # otherwise request from twilio like a gangster
        else
            url = String("/respondToVoiceCall?pluginHash=" + @hash)

            twiml = new Twilio.TwimlResponse()
            twiml.gather numDigits: 4, action: url, () ->
                twiml.say 'Yo! Please enter 4 digits.'
            response.send twiml.toString()

            # stop Doorman executing any more plugins
            global.dieNow = true


module.exports = getCode