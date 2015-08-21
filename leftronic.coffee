if not process.env.LEFTRONIC_KEY
    throw new Error 'Must specify LEFTRONIC_KEY environment variable'

module.exports = require('leftronic').createClient(process.env.LEFTRONIC_KEY)