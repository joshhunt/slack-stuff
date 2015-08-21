axios = require 'axios'
_ = require 'underscore'

SLACK_URL = process.env.SLACK_URL

if not SLACK_URL
  throw new Error 'Must specify SLACK_URL environment variable'

module.exports.send = (payload, opts = {}) ->

  if _.isString(payload)
    payload =
      text: payload

  payload = _.extend {}, payload, opts

  axios.post SLACK_URL, payload