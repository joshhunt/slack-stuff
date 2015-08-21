# module.exports = function (req, res, next) {
#   var userName = req.body.user_name;
#   var botPayload = {
#     text : 'Hello, ' + userName + '!'
#   };

#   // avoid infinite loop
#   if (userName !== 'slackbot') {
#     return res.status(200).json(botPayload);
#   } else {
#     return res.status(200).end();
#   }
# }


module.exports = (req, res, next) ->
  userName = req.body.user_name
  botPayload = {text: "Hello, #{userName}!"}

  if userName is 'slackbot'
    return res.status(200).end()

  return res.json(botPayload)