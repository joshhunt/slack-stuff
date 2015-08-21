leftronic = require '../leftronic'
giphy     = require '../giphy'

GOD = process.env.GOD
URL_REGEX = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
TRENDING_REGEX = /^trending[\.\s]?([\d+])?$/

try
  CHANNEL_TO_LEFTRONIC_STREAM_NAME = JSON.parse(process.env.CHANNEL_TO_LEFTRONIC_STREAM_NAME)
catch e
  CHANNEL_TO_LEFTRONIC_STREAM_NAME = {}
  console.warn 'Warning, you should set environment variable CHANNEL_TO_LEFTRONIC_STREAM_NAME. See readme for more details'

module.exports = (req, res, next) ->

  gifViaUrl = (newGifUrl, friendlyUrl) ->
    payload =
      streamName: leftronicStreamName
      imgUrl: newGifUrl

    console.log 'Posting new image to leftronic stream', leftronicStreamName
    leftronic.pushImage payload, (err, resp) ->
      throw err if err
      res.send 'Dashboard Gif changed to ' + (friendlyUrl or newGifUrl)

  gifViaSearch = ->
    giphy.search newGif
      .then ({data}) ->
        gifViaUrl data.data.image_url

  gifViaTrending = ->
    trendingResultIndex = newGif.match(TRENDING_REGEX)[1] or 0

    if trendingResultIndex
      trendingResultIndex = trendingResultIndex - 1

    giphy.trending()
      .then ({data}) ->
        trendingGifs = data.data
        theGif = trendingGifs[trendingResultIndex]
        gifViaUrl theGif.images.original.url, theGif.bitly_gif_url

  channel = req.body.channel_name
  username = req.body.user_name
  newGif = req.body.text

  console.log "Lol, @#{username} in ##{channel} is running command `#{newGif}`"

  leftronicStreamName = CHANNEL_TO_LEFTRONIC_STREAM_NAME[channel]

  if not newGif
    return res.send """
                    Oh hey, use this slack command to send gifs to a Leftronic Dashboard that's been set up for your channel.
                    Commands are:
                      - /setgif http://server.com/lol.gif - Set gif to a URL
                      - /setgif trending - Set gif the top trending gif from Giphy
                      - /setgif my search term - Set gif to a random gif for that tag (similar to /giphy)

                    #{GOD} made this, so ping him if you have questions
                    """

  # Do some validation first
  if not leftronicStreamName
    msg = "Sorry, I don't know which dashboard I should update from this channel. I know about:"
    for chName, strmName of CHANNEL_TO_LEFTRONIC_STREAM_NAME
      msg += "\n  - ##{chName}: #{strmName}"

    return res.send(msg)

  # And then switch the functionality depending on the command
  if URL_REGEX.test(newGif)
    console.log ' - using URL method'
    gifViaUrl newGif
  else if TRENDING_REGEX.test(newGif)
    console.log ' - using trending method'
    gifViaTrending newGif
  else
    console.log ' - using search method'
    gifViaSearch newGif