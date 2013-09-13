# flowdock-notify

Send a build success/failure notification to a FlowDock team inbox

# Box Requirements

 * Ruby 1.9.3 or Ruby 2.0.x
 * or, Ruby 1.8.7 with the 'json' gem installed.

# Options

* `flow-api-token` (required) Your API token for the chosen team inbox
* `from-address` (required) Email address notifications should appear to be sent from

# Example

```yaml
build:
  after-steps:
    - mipearson/flowdock-notify:
        flow-api-token: $TOKEN
        from-address: bob@thebuilder.com.au
```

# TODO

* Deploy notifications
* Message customisation

# License

The MIT License (MIT)

Copyright (c) 2013 Michael Pearson

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Changelog

## v0.0.1 Initial release
