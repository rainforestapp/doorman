# Print console output
sendSms = {}
sendSms.runOnTrue = true
sendSms.runOnFalse = true

sendSms.run = (request, twiml) ->
    console.log 'running sms'

module.exports = sendSms