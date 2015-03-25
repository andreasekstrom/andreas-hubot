# Description:
#   Find whats for lunch today at Sven Dufva (not very useful if you are not located in Uppsala, Sweden)
#
# Commands:
#   hubot <lunch at> dufva
        
Crawler = require("crawler");

module.exports = (robot) ->
  robot.respond /dufva/i, (msg) ->
    scrapeLunch(msg)

scrapeLunch = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->

      text = $('table[bgcolor="#EEEEEE"]').find('td.text').text()
      items = text.split('- ')
      for item in items 
        do ->
          menu.push "#{item}\n"
      msg.send "Lunch: #{menu.join('')}"
  c.queue("http://www.svendufva.com/")
