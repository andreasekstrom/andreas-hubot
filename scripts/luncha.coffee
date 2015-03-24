# Description:
#   Find whats for lunch today at some places near UCR, Uppsala
#
# Commands:
#   hubot luncha
        
Crawler = require("crawler").Crawler;
moment = require("moment");

swedishWeekdays = ['SÖNDAG','MÅNDAG', 'TISDAG', 'ONSDAG', 'TORSDAG', 'FREDAG', 'LÖRDAG']

module.exports = (robot) ->
  robot.respond /luncha/i, (msg) ->
    scrapeDufva(msg)
    scrapePrimaten(msg)

scrapeDufva = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->

      text = $('table[bgcolor="#EEEEEE"]').find('td.text').text()
      items = text.split('- ')
      for item in items 
        do ->
          menu.push "#{item}\n"
      msg.send "Dufva: #{menu.join('')}"
  c.queue("http://www.svendufva.com/")

scrapePrimaten = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->

      week = $("h3:contains('HELA VECKAN')")
      for item in ['SOPPA', 'LYX']
        do ->
          theme = week.nextAll("p:contains('#{item}')")
          menu.push "#{item} - #{theme.next("p").text()}"
          
      weekday = moment().weekday()
      swedishName = swedishWeekdays[weekday]
      day = $(".veckomeny-text h3:contains(#{swedishName})")
      
      menu.push "Special #{swedishWeekdays[weekday]} - #{day.next("p").text()}"
      
      msg.send "Primaten: \n#{menu.join('\n')}"
  c.queue("http://primaten.org/restaurangen/")
