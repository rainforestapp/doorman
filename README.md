Doorman
=======

Doorman is your own personal doorman. Who wants to constantly be answering the phone and trying to communicate over patchy audio with someone outside? Nobody! Who wants to unwittingly let in a gang of young street ruffians who are out to plunder your treasures? Nobody! Who wants to be living in the age of manually doing _anything_? __Nobody!__

Enter Doorman. 

Doorman is a nice little [Node.js](http://nodejs.org/) app that makes it super easy to script your building door keypad-entry system, using [Twilio](https://www.twilio.com/) and [CoffeeScript](http://coffeescript.org/). It's a minimal backbone on top of which you write plugins to determine who to let in your building and when. Doorman is extensible as hell and the possibilities are basically endless. All you need is a building keycode system that responds to TouchTones ([DTMF](http://en.wikipedia.org/wiki/Dual-tone_multi-frequency_signaling)), a Twilio number and a Heroku dyno. Excited? Let's get started!

# Requirements

There are a couple of components to Doorman. None of them are too onerous, so don't be put off. We reckon you can get Doorman working in about 15 minutes.

## Twilio
This part is super simple. Go [sign up for Twilio](https://www.twilio.com/try-twilio) and [buy a number](https://www.twilio.com/user/account/phone-numbers/available/). That's it. Once Doorman is deployed to Heroku you will point the number at the Heroku url. For now we'll just forward this to your number, so if anyone tries to use your door while Doorman is getting setup there won't be any locked-out shenanigans. [Edit the number](https://www.twilio.com/user/account/phone-numbers), and set the Voice Request URL to ```http://twimlets.com/forward?PhoneNumber=123-456-7890``` and replace the number with your own.

## A building manager
Hopefully your building manager thinks you're rad because you buy them flowers, as you're going to need their help. They can program your building entry system to call any arbitrary phone number when your apartment number is pressed. Have them change the number to the [Twilio number](https://www.twilio.com/user/account/phone-numbers) you just bought. Thank them profusely and always recycle.

## Heroku
Heroku is so awesome for this kind of stuff. [Set up an account](https://api.heroku.com/signup) and create a small instance. Configure it and stuff and link it to your fork of Doorman. Then BOOM. Once Doorman is running on Heroku, point [your number](https://www.twilio.com/user/account/phone-numbers) to your Heroku app URL.

# Setup

Do some stuff.

# How it works

All of Doorman's logic and actions are defined in plugins. There are three kinds of plugins: decisions, sources and actions.

## Decision plugins
These are how you decide whether to let someone in your door or not. We include a few default decision plugins in the repo as examples, like ```alwaysTrue``` and ```alwaysFalse``` (they do exactly what you imagine). So if you want to let everyone that ever dials your code into your building, just enable alwaysTrue (probably don't do this). This is the alwaysTrue plugin:
```coffeescript
Plugin = require '../plugin'

class alwaysTrue extends Plugin

    run: (callSid, request, response) =>
        return true

module.exports = alwaysTrue
```

Each decision plugin operates in a flow, and returns either true or false. If a decision plugin returns false, the next plugin in line is called. If it returns true, Doorman jumps straight to your Action plugins. But first, a word on Sources.

## Source plugins
Source plugins are meant for data gathering. Normally a Decision plugin is sufficient for simple data gathering, but for stuff where you need user keypad input, using a Source plugin is way easier. Asking Twilio for additional input from the user means your app will get restarted when Twilio returns the user's responses (since Twilio is non-streaming), and so there's all kinds of caching and futzing that needs to go on for Doorman to work efficiently. Source plugins are a nice way to keep this logic separate from the simpler Decisions and Actions. We included this ```askForCode``` plugin, but you can write basically whatever you want within the bounds of the [Twilio Twiml API](https://www.twilio.com/docs/api/twiml).
```coffeescript
# if the data is there already and equals what is expectedDigits, just return it
if global.data[callSid][@hash]?.data?.Digits? is true and global.data[callSid][@hash].data.Digits is expectedDigits
    return global.data[callSid][@hash].data.Digits

# otherwise request from twilio like a gangster
else
    # add current plugin hash as GET param so we know which one to save the returned data to
    url = String("/respondToVoiceCall?pluginHash=" + @hash)

    twiml = new Twilio.TwimlResponse()
    twiml.gather numDigits: 4, action: url, () ->
        twiml.say 'Yo! Please enter 4 digits.'
    response.send twiml.toString()

    # stop Doorman executing any more plugins
    global.dieNow = true
```

## Action plugins
Doorman's whole aim is to make your life easy, so these guys are crucial. Action plugins define what you want to do when your set of Decision plugins have either returned true or false. The most important Action plugin is _definitely_ playEnterTone which opens the apartment door:
```coffeescript
# play dial tonez
twiml = new Twilio.TwimlResponse()
twiml.play "http://www.dialabc.com/i/cache/dtmfgen/wavpcm8.300/9.wav", loop: 50
response.send twiml.toString()
```

There are tons of things you can do with actions. We have our office lights change color when someone comes in the door, as well as ping us in our HipChat common room with the name of the person (we use Facebook to pre-approve people and generate unique entry codes, so we can identify them by code when they come in). You could do almost anything!

# Interview hacks!

Doorman was the product of a one-day interview hack, something we do at [Rainforest](https://www.rainforestqa.com) whenever we really like a developer and we think we want them to be part of our team. At the beginning of the day we have breakfast together and figure out what we want to build, and commit to Open Sourcing it (thus avoiding pesky IP problems and code-base learning biases) by the end of the same day. Then we do it! Doorman was pretty rad because none of us had any real experience of building [Node](https://github.com/joyent/node) or [Express](https://github.com/visionmedia/express) apps (as you can see by looking at our commits :).

If that sounds like fun, we're looking for sociable and creative inverterate hackers to come and join [Rainforest](https://www.rainforestqa.com) in San Francisco, so [get in touch](mailto:hello@rainforestqa.com?subject=Nice Doorman hack dudes!).

# Wut now?

Doorman is wholeheartedly Open Source, so please fork, update, betterize, pull request and hack the heck out of it. We hope you're as excited about the possibilities of this usually mundane aspect to office / apartment life as we are :)

# Lame legal stuff for Captain Obvious / Disclaimer

Whatever may or may not happen as a result of using Doorman is entirely your own fault and nothing to do with Rainforest or any of the contributors to Doorman. By running Doorman you accept responsibility for whatever happens and release the Doorman contributors and Rainforest from all liability should something go awry. In short, be smart.