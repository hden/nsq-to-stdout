'use strict'

util    = require 'util'

debug   = require('debug')('nsq:main')
program = require 'commander'
nsq     = require 'nsq.js'

program
.version(require("#{__dirname}/../package.json").version or '0.0.1')
.option('-h, --host     [host:port]', 'nsqlookupd', ':4161')
.option('-t, --topic    [topic]', 'nsq topic to monitor')
.option('-c, --channel  [channel]', 'nsq channel', 'debug')
.option('-p, --prettyfy', 'prettyfy JSON message')
.parse(process.argv)

program.help() unless program.topic?

reader = nsq.reader {
  nsqlookupd: [program.host]
  topic: program.topic
  channel: program.channel
}

reader.on 'error', (error) ->
  debug 'nsq error: %s', error

console.log program

reader.on 'message', (msg) ->
  msg.finish()
  if program.prettyfy
    util.log msg.body.json()
  else
    console.log msg.body.toString()
