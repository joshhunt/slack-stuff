express    = require 'express'
bodyParser = require 'body-parser'

{requireSlackToken} = require './middleware'

hellobot   = require './routes/hellobot'
setGif     = require './routes/setGif'

app = express()
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: true })

app.get '/', (req, res) -> res.send("<pre>Cool.</pre>")

app.post '/hello',  requireSlackToken, hellobot
app.post '/setGif', requireSlackToken, setGif

app.use (err, req, res, next) ->
    res.status(400).send("<pre>#{err.stack or 'Unknown error'}</pre>")

port = process.env.PORT or 3000
app.listen port, ->
    console.log 'Slack bot listening on port ' + port