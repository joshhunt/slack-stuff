express    = require 'express'
bodyParser = require 'body-parser'

hellobot   = require './routes/hellobot'
setGif     = require './routes/setGif'

app = express()
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))

app.get '/', (req, res) -> res.json({'Hello': 'World'})
app.post '/hello', hellobot
app.post '/setGif', setGif

app.use (err, req, res, next) ->
    console.error err.stack
    errLines = (err.stack or '').split('\n')
    res.status(400).send({error: errLines})

port = process.env.PORT or 3000
app.listen port, ->
    console.log 'Slack bot listening on port ' + port