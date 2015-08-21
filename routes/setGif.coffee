leftronic = require '../leftronic'
giphy     = require '../giphy'

URL_REGEX = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
TRENDING_REGEX = /^trending[\.\s]?([\d+])?$/

CHANNEL_TO_LEFTRONIC_STREAM_NAME = {
  'tv':          'tvGif'
  'tv-services': 'tvGif'
  'tv-web':      'tvGif'
}

module.exports = (req, res, next) ->

  postReply = (newGifUrl, friendlyUrl) ->
    payload =
      streamName: leftronicStreamName
      imgUrl: newGifUrl

    leftronic.pushImage payload, (err, resp) ->
      throw err if err
      res.send 'Dashboard Gif changed to ' + (friendlyUrl or newGifUrl)

  gifViaSearch = ->
    giphy.search newGif
      .then ({data}) ->
        postReply data.data.image_url

  gifViaTrending = ->
    trendingResultIndex = newGif.match(TRENDING_REGEX)[1] or 0

    if trendingResultIndex
      trendingResultIndex = trendingResultIndex - 1

    giphy.trending()
      .then ({data}) ->
        trendingGifs = data.data
        theGif = trendingGifs[trendingResultIndex]
        postReply theGif.images.original.url, theGif.bitly_gif_url

  channel = req.body.channel_name
  username = req.body.user_name
  newGif = req.body.text

  console.log "Lol, @#{username} in ##{channel} is running command `#{newGif}`"

  leftronicStreamName = CHANNEL_TO_LEFTRONIC_STREAM_NAME[channel]

  # Do some validation first
  if not leftronicStreamName
    msg = "Sorry, I don't know which dashboard I should update from this channel. I know about:"
    for chName, strmName of CHANNEL_TO_LEFTRONIC_STREAM_NAME
      msg += "\n  - ##{chName}: #{strmName}"

    return res.send(msg)

  if not newGif
    return res.send "Doh! You forgot to pass in a gif URL"

  # And then switch the functionality depending on the command
  if URL_REGEX.test(newGif)
    console.log ' - using URL method'
    postReply newGif
  else if TRENDING_REGEX.test(newGif)
    console.log ' - using trending method'
    gifViaTrending newGif
  else
    console.log ' - using search method'
    gifViaSearch newGif