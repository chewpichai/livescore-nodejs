_       = require 'underscore'
events  = require 'events'
moment  = require 'moment'
request = require 'request'
xml2js  = require 'xml2js'


THSCORE_URL = 'http://www.thscore.cc'
xmlParser = new xml2js.Parser();


parseDate = (date) ->
  moment.utc date.split(',')


class LiveScore extends events.EventEmitter
  constructor: ->
    @start()

  start: =>
    ShowBf = ->
    url = "#{THSCORE_URL}/data/bf_th1.js?" + Date.parse(new Date())
    
    request.get url, (err, response, body) =>
      if err then return setTimeout @start, 3000
      
      eval body
      @matches = A
      @leagues = B
      @countries = C
      setTimeout @refresh, 3000

  refresh: =>
    url = "#{THSCORE_URL}/data/change_en.xml?" + Date.parse(new Date())
    
    request.get url, (err, response, body) =>
      setTimeout @refresh, 3000

      if err then return

      xmlParser.parseString body, (err, result) =>
        if result.c.$.refresh != '0'
          setTimeout @start, Math.floor(20000 * Math.random())

        if not result.c.h? then return

        for h in result.c.h
          d = h.split '^'
          # console.log d


exports.livescore = new LiveScore()
