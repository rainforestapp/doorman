playMp3 = {}

playMp3.run = (request, response) ->

    twiml = new Twilio.TwimlResponse()
    twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50

    console.log 'playing mp3'

    response.pipe twiml.toString(), end: false

module.exports = playMp3