# Description:
#   Find whats for lunch today at some places near UCR, Uppsala, Sweden
#
# Commands:
#   hubot luncha
        
Crawler = require("crawler");
moment = require("moment");

module.exports = (robot) ->
  robot.respond /luncha/i, (msg) ->
    msg.send "Idag (#{toDayInSwedish()}) får ni välja på... \n\n"
    
    scrapeDufva(msg)
    scrapePrimaten(msg)
    #scrapeOlof(msg)
    scrapeThaibreak(msg)

scrapeDufva = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->

      day = $("#lunchPrint h4:contains(#{toDayInSwedish()})")
      dishes = ((day = day.next("p")).text() for n in [1..4])

      for item in dishes 
        do ->
          menu.push "* #{item}\n"
      msg.send "\nDufva:\n#{menu.join('')}"
  c.queue("http://www.svendufva.se/")

scrapePrimaten = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->
          
      day = $(".veckomeny-text h3:contains(#{toDayInSwedish().toUpperCase()})")
      menu.push "Special idag: #{day.next("p").text()}"
      
      msg.send "\nPrimaten: \n#{menu.join('\n')}"
  c.queue("http://primaten.org/restaurangen/")

scrapeThaibreak = (msg) ->
  menu = []
  c = new Crawler
    "forceUTF8":true,
    "callback": (error,result,$) ->

      day = $(".sidebar_content h3:contains(#{toDayInSwedish()})")
      dishes = ((day = day.next("p")).text() for n in [1..4])

      msg.send "\nThaibreak\n#{dishes.join('\n')}"
      
  week_description = if (moment().week() % 2 == 0) then "jamn-vecka" else "udda-vecka"
  c.queue("http://www.thaibreak.se/" + week_description)

toDayInSwedish = ->
  swedishWeekdays = ['Söndag','Måndag', 'Tisdag', 'Onsdag', 'Torsdag', 'Fredag', 'Lördag']
  weekday = moment().weekday()
  swedishWeekdays[weekday]    









# Legacy - Café Olof är (åtminstone tillfälligt) stängt...
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
