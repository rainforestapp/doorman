# Define app and get require
express = require 'express'
app = express()

# Setup first route
app.get '/', (request, response) =>
  response.send 'Hello World'

# bind and listen for connection
app.listen process.env.PORT || 5000
console.log 'listening on port erm...'