var ProcessChannel = require('../lib/process-channel').ProcessChannel;

var channelId = process.argv.pop()
var channel = new ProcessChannel(process, channelId);

channel.on('greet', function(name) {
  channel.send('response', 'Hello ' + name);
});

channel.send('ready');
