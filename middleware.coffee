SLACK_TOKEN = process.env.SLACK_TOKEN

module.exports.requireSlackToken = (req, res, next) ->
    if not SLACK_TOKEN
        throw new Error 'Must specify SLACK_TOKEN environment variable'

    if req.body?.token isnt SLACK_TOKEN
        return res.status(403).send('Not allowed')

    next()
