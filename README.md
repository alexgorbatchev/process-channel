# process-channel

[![GitTip](http://img.shields.io/gittip/alexgorbatchev.svg?style=flat)](https://www.gittip.com/alexgorbatchev/)
[![Dependency status](http://img.shields.io/david/alexgorbatchev/process-channel.svg?style=flat)](https://david-dm.org/alexgorbatchev/process-channel)
[![devDependency Status](http://img.shields.io/david/dev/alexgorbatchev/process-channel.svg?style=flat)](https://david-dm.org/alexgorbatchev/process-channel#info=devDependencies)
[![Build Status](http://img.shields.io/travis/alexgorbatchev/process-channel.svg?style=flat&branch=master)](https://travis-ci.org/alexgorbatchev/process-channel)

[![NPM](https://nodei.co/npm/process-channel.svg?style=flat)](https://npmjs.org/package/process-channel)

This module facilitates event based communication between parent and child process.

## Installation

    npm install process-channel

## Usage Example

worker.js

```javascript
var ProcessChannel = require('../lib/process-channel').ProcessChannel;

var channelId = process.argv.pop()
var channel = new ProcessChannel(process, channelId);

channel.on('greet', function(name) {
  channel.send('response', 'Hello ' + name);
});

channel.send('ready');
```

server.js

```javascript
var fork = require('child_process').fork;
var ProcessChannel = require('process-channel').ProcessChannel;

var channelId = 123;
var worker = fork(__dirname + "/worker.js", [channelId]);
var channel = new ProcessChannel(worker, channelId);

channel.once('response', function(greeting) {
  console.log(greeting);
  worker.kill();
});

channel.once('ready', function() {
  channel.send('greet', 'Alex');
});
```

This should print out `Hello Alex`.

## API

### ProcessChannel(process, channelId)

* `process` - `Process` is a process to send to and receive messages from. Typically server would pass in the forked process and the worker would pass in the current process.
* `channelId` - `Number` is a unique channel number that is the same on the server and worker. It's used to differentiate messages coming from multiple workers.

### channel.send(type, data)

* `type` - `String` is event type/name.
* `data` - is stringified and sent to the other process.

### channel.on(type, handler)

* `type` - `String` is event type/name.
* `handler` - `function(data)` is a callback function which receives data from the `send` method.

## Testing

    npm test

## License

The MIT License (MIT)

Copyright 2014 Alex Gorbatchev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
