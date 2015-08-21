leftronic = require '../leftronic'

CHANNEL_TO_LEFTRONIC_STREAM_NAME = {
  'tv':          'tvGif'
  'tv-services': 'tvGif'
  'tv-web':      'tvGif'
}

module.exports = (req, res, next) ->
  channel = req.body.channel_name
  newGifUrl = req.body.text

  leftronicStreamName = CHANNEL_TO_LEFTRONIC_STREAM_NAME[channel]

  if not leftronicStreamName
    msg = "Sorry, I don't know which dashboard I should update from this channel. I know about:"
    for chName, strmName of CHANNEL_TO_LEFTRONIC_STREAM_NAME
      msg += "\n  - ##{chName}: #{strmName}"

    return res.send(msg)

  if not newGifUrl
    return res.send "Doh! You forgot to pass in a gif URL"

  payload =
    streamName: leftronicStreamName
    imgUrl: newGifUrl

  leftronic.pushImage payload, (err, resp) ->
    throw err if err
    res.send 'Dashboard updated!'