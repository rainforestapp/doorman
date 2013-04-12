sys = require 'sys'
TwilioClient = require('twilio').Client
Twiml = require('twilio').Twiml
express = require 'express'

ACCOUNT_SID = "AC1ce0d8d7a79de22f4c27bed657e8e810"
AUTH_TOKEN = "20f65a9da68ec4630c9c43d19baef94e"
HOSTNAME = "204.14.154.40"

PORT=6000

app = express()
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)
app.use (err, req, res, next) ->
  console.error(err.stack)
  res.send(500, 'Something broke!')


currentCallSid = null
client = new TwilioClient(ACCOUNT_SID, AUTH_TOKEN, HOSTNAME, express: app)

app.get '/open_door', (req, res) ->
  if currentCallSid
    opts = 
      Url: "http://#{HOSTNAME}:#{PORT}/dial_nine"
   
    client.apiCall('POST', "/Calls/#{currentCallSid}", {params: opts})
    res.send 'Tone sent'

  res.send 'No current call'


app.post '/dial_nine', (req, res) ->
  console.log "Sending 9"
  twilioResponse = new Twiml.Response(res)
  twilioResponse.append new Twiml.Play("http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50)

  res.setHeader('Content-Type', 'text/xml')
  
  twilioResponse.send()


app.listen(PORT)


phone = client.getPhoneNumber('+14155240379')

phone.setup ->
    
  # Oh, and what if we get an incoming call?
  phone.on 'incomingCall', (reqParams, res) ->
    console.log('incoming')
    console.log(reqParams)
    currentCallSid = reqParams.CallSid

    res.append new Twiml.Say('Welcome to Rainforest! Please enter your PIN')

    gatherCode = new Twiml.Gather(null, {numDigits: 4})
    gatherCode.on 'gathered', (reqParams, res) ->
      console.log(arguments)
      console.log('User pressed: ' + reqParams.Digits)

      if reqParams.Digits == '1234'
        console.log('PIN is correct')
        res.append new Twiml.Play("http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50)
      else
        console.log('PIN is incorrect')
      res.append new Twiml.Hangup()
      res.send()
        

    res.append gatherCode
    res.send()
