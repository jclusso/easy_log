[![Build Status](https://travis-ci.org/jclusso/easy_log.svg)](https://travis-ci.org/jclusso/easy_log)
[![Code Climate](https://codeclimate.com/github/jclusso/easy_log/badges/gpa.svg)](https://codeclimate.com/github/jclusso/easy_log)

# EasyLog

![Image of a log](http://i.imgur.com/AqsbKBs.png "Image of a log")

EasyLog was created to make it easy and quick to output detailed log messages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_log'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_log

And then include at top of any class
```ruby
class Customer
  include EasyLog

  def create
    ...
  end
end
```

For usage in [sidekiq](https://github.com/mperham/sidekiq), set the logger to
sidekiq's logger in the `configure_server` block:

```ruby
Sidekiq.configure_server do |config|
  EasyLog.set_logger config.logger
end
```

## Usage

```ruby
class Customer
  include EasyLog

  def create(name, gender)
    # useful at the beginning of a method
    log(:start)
    # Customer#create: STARTED! w/ name: Jarrett gender: male

    # a general log message
    log('Customer Signup from Google Campaign.')
    # Customer#create: Customer Signup Complete! w/
    # name: Jarrett gender: male


    # a simple success message
    log(:success) 'Customer Signup Complete!'
    # Customer#create: SUCCESS: Customer Signup Complete! w/
    # name: Jarrett gender: male

    # or an error message
    log(:error) 'External API Failed To Connect!'
    # Customer#create: ERROR: External API Failed To Connect w/
    # name: Jarrett gender: male

    # pass additional parameters in
    log(:error) 'External API Failed To Connect!', plan_id: '4'
    # Customer#create: ERROR: Exteranl API Failed To Connect w/
    # name: Jarrett gender: male plan_id: 4

    # will even include instance variables if found
    @customer_id = '1'
    log(:success) 'Customer Signup Complete!'
    # Customer#create: SUCCESS: Customer Signup Complete! w/
    # @customer_id: 1 name: Jarrett gender: male

    # useful at the end of a method
    log(:finish)
    # Customer#create: FINISHED! w/ name: Jarrett gender: male
  end
end
```

The `EasyLog.set_logger` function can be used to set any class as the logger,
as long as it responds to `#info`. In Rails apps, it will use the Rails logger
as default.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jclusso/easy_log. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
