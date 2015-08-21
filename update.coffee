axios = require 'axios'
leftronic = require './leftronic'

cb = (err, resp) ->
    throw err if err
    console.log resp

leftronic.pushImage {
    streamName: 'tvCustomImage1'
    imgUrl: 'http://media.giphy.com/media/kf0oMQDNZQ1So/giphy.gif'
}, cb