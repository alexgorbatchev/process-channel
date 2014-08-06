{EventEmitter} = require 'events'

class ProcessChannel extends EventEmitter
  constructor: (@process, channelId) ->
    @channelId = channelId.toString()

    handler = (json) =>
      {type, data, id} = JSON.parse json
      @emit type, data if @channelId is id

    @process.on 'message', handler

  send: (type, data) ->
    @process.send JSON.stringify {type, data, id: @channelId}

module.exports = {ProcessChannel}
