application_root = __dirname
express = require "express"
path = require "path"

app = express()

app.configure ( =>
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(application_root, "public"))
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
  )


app.get '/', (req, res) ->
  res.send 'Hello World'


app.get '/api/modules', (req, res) ->
  res.send [{name: 'test'}]

app.get '/api/modules/:name', (req, res) ->
  res.send {name: req.params.name}


app.listen(3000);
console.log('Listening on port 3000');