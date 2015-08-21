module.exports = (req, res, next) ->
  userName = req.body.user_name
  botReply = "Hello, #{userName}!"

  console.log req.body

  if userName is 'slackbot'
    return res.status(200).end()

  return res.json(botReply)