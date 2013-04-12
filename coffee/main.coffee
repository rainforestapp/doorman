ACCOUNT_SID = "AC1ce0d8d7a79de22f4c27bed657e8e810"
AUTH_TOKEN = "20f65a9da68ec4630c9c43d19baef94e"
HOSTNAME = "204.14.154.40:6000"

sys = require('sys')
TwilioClient = require('twilio').Client
client = new TwilioClient(ACCOUNT_SID, AUTH_TOKEN, HOSTNAME)

phone.setup ->
  # Oh, and what if we get an incoming call?
  phone.on 'incomingCall', (reqParams, res) ->
    res.append(new Twiml.Say('Thanks for calling! I think you are beautiful!'))
    res.send()

