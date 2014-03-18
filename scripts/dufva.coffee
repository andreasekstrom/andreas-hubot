# Description:
#   Find whats for lunch today at Sven Dufva (not very useful if you are not located in Uppsala, Sweden)
#
# Commands:
#   hubot lunch at dufva
        
cheerio = require('cheerio')

module.exports = (robot) ->
  robot.respond /at dufva/i, (msg) ->
    
  	msg
      .http("http://www.svendufva.com/")
      .get() (err, res, body) ->
        msg.send "Today: #{getLunch(body, msg)}"

getLunch = (body, msg) ->
  menu = []
  $ = cheerio.load(body)
  text = $('table[bgcolor="#EEEEEE"]').find('td.text').text()
  items = text.split('- ')
  for item in items 
    do ->
      menu.push "#{item}<BR>"
  menu    