# Description:
#   Find whats for lunch today at some places near UCR, Uppsala
#
# Commands:
#   hubot luncha
        
Crawler = require("crawler");
moment = require("moment");

swedishWeekdays = ['Söndag','Måndag', 'Tisdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lördag']

module.exports = (robot) ->
  robot.respond /luncha/i, (msg) ->
    scrapeDufva(msg)
    scrapePrimaten(msg)
    scrapeOlof(msg)

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

      weekItems = $("div.hela-veckan").find('p')
      menu.push "Hela veckan:"
          
      for item in weekItems
        do ->
          menu.push "#{$(item).text().replace(/(\r\n|\n|\r)/gm," - ")}"
          
      weekday = moment().weekday()
      swedishName = swedishWeekdays[weekday].toUpperCase()
      day = $(".veckomeny-text h3:contains(#{swedishName})")
      
      menu.push "Special #{swedishWeekdays[weekday]} - #{day.next("p").text()}"
      
      msg.send "Primaten: \n#{menu.join('\n')}"
  c.queue("http://primaten.org/restaurangen/")

scrapeOlof = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->

      weekday = moment().weekday()
      swedishName = swedishWeekdays[weekday]
      day = $("table.menytext strong:contains(#{swedishName})")
      
      tables = $(day).parent().parent().nextAll("tr").find("table") 
      todaysMeal =  $(tables[0]).text().replace(/(\r\n|\n|\r)/gm,"").trim()

      msg.send "\nCafé Olof: #{day.text()} #{todaysMeal}"
  c.queue("http://www.cafeolof.se/")
