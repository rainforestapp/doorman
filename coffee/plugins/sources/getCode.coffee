Twilio = require 'twilio'
Plugin = require '../plugin'

class getCode extends Plugin

    runOnTrue: true

    run: (callSid, request, response) ->

        twiml = new Twilio.TwimlResponse()
        twiml.gather numDigits: 4, action: "/respondToVoiceCall?pluginHash=" + @hash, () ->
            twiml.say 'Please enter 4 digits:'


        response.send twiml.toString()
        console.log "Save the digits here: #{callSid} : #{@hash}"


module.exports = getCode