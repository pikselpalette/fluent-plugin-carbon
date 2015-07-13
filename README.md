# fluent-plugin-carbon

fluentd input plugin to create a carbon listener

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-carbon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-carbon

## Configuration

#### Example

- configuration

  ```
  <source>
    type carbon
    tag tcp.events
    format /^(?<key>\\S+)\\s+(?<val>\\S+)\\s+(?<time>\\S+)$/
    port 2003
    time_format %s
    bind 0.0.0.0
  </source>

  ```
#### Parameter

###### tag
- required.
- routing tag

###### port
- Default is `2003`.
- listening port of carbon-listener.

###### format
- Default is `/^(?<key>\\S+)\\s+(?<val>\\S+)\\s+(?<time>\\S+)$/`

###### time_format
- Default is `%s`.

###### bind
- Default is `0.0.0.0`.

## Contributing

1. Fork it ( http://github.com/sgran/fluent-plugin-carbon/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
