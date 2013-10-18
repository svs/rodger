# Rodger

Rodger is a Ruby interface to [John Wiegley's ledger-cli program](http://www.ledger-cli.org/)

## Installation

Add this line to your application's Gemfile:

    gem 'rodger'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rodger

### It is important to have the ledger-cli binary on your system.

## Usage

```ruby

@r = Rodger.new("accounts.cli")
@r.accounts # A hash with the accounts in it
@r.balance["Liabilities:Credit-Card:VISA"] # => The balance of a particular account
```

Check the specs for more usage examples

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
