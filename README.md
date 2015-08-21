# Slash commands

Quick and dirty Slack intergration, mainly for sending gifs to a leftronic board.

Set up some environment variables for the required config:

 * `CHANNEL_TO_LEFTRONIC_STREAM_NAME`: Should be a JSON string of an object that maps slack channel names to leftronic stream name.
 * `LEFTRONIC_KEY`: Leftronic API Key
 * `SLACK_TOKEN`: the slack token to verify Slash commands
 * `GOD`: name for the owner/creater of this. Used for help messages