ACCOUNT_SID = "AC1ce0d8d7a79de22f4c27bed657e8e810"
AUTH_TOKEN = "20f65a9da68ec4630c9c43d19baef94e"
HOSTNAME = "204.14.154.40"
PORT=6000

sys = require 'sys'
TwilioClient = require('twilio').Client
Twiml = require('twilio').Twiml

client = new TwilioClient(ACCOUNT_SID, AUTH_TOKEN, HOSTNAME, port: PORT)

phone = client.getPhoneNumber('+14155240379')

phone.setup ->

  # Oh, and what if we get an incoming call?
  phone.on 'incomingCall', (reqParams, res) ->
    console.log('incoming')
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
