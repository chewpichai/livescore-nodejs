_         = require 'underscore'
app       = require('express')()
http      = require('http').Server(app)
io        = require('socket.io')(http)
path      = require('path')
fs        = require('fs')
livescore = require('./livescore').livescore


render = (file, context) ->
  html = fs.readFileSync "templates/#{file}.html"
  template = _.template "#{html}"
  template(context)


app.get '/', (req, res) ->
  res.end render 'index',
    matches: livescore.matches
    leagues: livescore.leagues
    countries: livescore.countries


io.on 'connection', (socket) ->
  console.log 'a user connected'

  socket.on 'disconnect', ->
    console.log 'user disconnected'


http.listen 3000, ->
  console.log 'listening on *:3000'
