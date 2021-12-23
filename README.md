# attr_bool_accessor [![Gem Version](https://badge.fury.io/rb/bool_attr_accessor.svg)](https://badge.fury.io/rb/bool_attr_accessor) [![Build Status](https://github.com/marcrohloff/bool_attr_accessor/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/marcrohloff/bool_attr_accessor) [![Coverage Status](https://coveralls.io/repos/github/marcrohloff/bool_attr_accessor/badge.svg?branch=main)](https://coveralls.io/github/marcrohloff/bool_attr_accessor?branch=main)

**attr_bool_accessor** is a gem for adding boolean style attributes to classes.

For example:

```ruby
  class User
    battr_accessor :enabled
  end

  u = User.new
  u.enabled?
```

## Installation

Just like any other gem. Just add
```
gem "attr_bool_accessor"
```
to your Gemfile or run
```
gem install attr_bool_accessor
```


## Usage

For basic usage it can be used similarly to an `attr_accessor`

```ruby
  class User
    battr_accessor :enabled
  end
```

Which provides some basic accessor methods:
```ruby
  u = User.new
  u.enabled?         # => false
  u.enabled!         # set it to true
  u.enabled?         # => true
  u.enabled = false  # set it to a value
  u.enabled?         # => false
```

The *query* method `attribute?` always returns a `true` or `false` value.  
The *bang* method (`attribute!`) sets the attribute to `true`.  
The *writer* method (`attribute=`) allows you to set the attribute. Values will be converted to boolean.  

You can provide multiple attribute names, use strings and use names that include a trailing question mark

```ruby
  class User
    battr_accessor :first, :second, 'third', :fourth?
  end
```

You can also use `attr_boolean` as an alias for `battr_accessor`

```ruby
  class User
    attr_boolean :enabled
  end
```

##### Options

The following options are accepted:

**`default`**:
sets the default (initial) value for the attribute (`false` by default)

**`bang`**:
Set to `false` to disable the bang (`attribute!`) method (`true` by default)

**`writer`**:
Set to `false` to disable the writer (`attribute=`) method (by default the writer is enabled if the bang method is enabled)

**`reader`**:
Set to `true` to disable the reader (`attribute`)  method (this is enabled if the `raw` option is set)

**`raw`**:
Enables raw mode.
This makes a few changes.   
Default and assigned values are stored internally in the value provided and not converted to boolean values  
 A `reader` method is added that allows you to read the raw value.   
 The query method will always return a boolean.  

##### Examples

```ruby
  class User
   battr_accessor :enabled, default: true, writer: false
  end

  class Account
   battr_accessor :state, default: 3, raw: true
  end

  a = Account.new
  a.state       # => 3
  a.state?      # => true
  a.state = nil
  a.state       # => nil
  a.state?      # => false
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcrohloff/attr_bool_accessor.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Author

Created by Yuri Smirnov.
