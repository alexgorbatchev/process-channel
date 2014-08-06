require 'coffee-errors'

chai = require 'chai'
sinon = require 'sinon'
{fork} = require 'child_process'
# using compiled JavaScript file here to be sure module works
{ProcessChannel} = require '../lib/process-channel.js'

expect = chai.expect
chai.use require 'sinon-chai'

describe 'process-channel', ->
  worker = null
  channel = null

  before (done) ->
    channelId = 123
    worker = fork "#{__dirname}/worker.js", [channelId]
    channel = new ProcessChannel worker, channelId
    channel.once 'ready', done

  it 'can send and receive messages', (done) ->
    channel.send 'greet', 'Alex'
    channel.once 'response', (greeting) ->
      expect(greeting).to.eql 'Hello Alex'
      worker.kill()
      done()
