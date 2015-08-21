axios = require 'axios'
_ = require 'underscore'
urlLib = require 'url'
querystring = require 'querystring'

# We hardcode this because it's the same token for everyone.
GIPHY_TOKEN = process.env.GIPHY_TOKEN or 'dc6zaTOxFJmzC'
GIPHY_URL_BASE = 'http://api.giphy.com/v1'

createUrl = (endpoint, params = {}) ->
  baseUrl = "#{GIPHY_URL_BASE}/#{endpoint}"
  parsedUrl = urlLib.parse baseUrl
  query = _.extend({}, {api_key: GIPHY_TOKEN}, params)

  parsedUrl.query = query

  return urlLib.format(parsedUrl)

module.exports = giphy = (endpoint, params = {}) ->
  url = createUrl endpoint, params
  console.log 'Hitting', url
  axios.get url

module.exports.search = (searchTerm) ->
  giphy 'gifs/random', {tag: searchTerm}

module.exports.trending = ->
  giphy 'gifs/trending'