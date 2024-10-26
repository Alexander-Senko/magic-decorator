# 🪄 Magic Decorator

![Code Climate maintainability](
	https://img.shields.io/codeclimate/maintainability-percentage/Alexander-Senko/magic-decorator
)
![Code Climate coverage](
	https://img.shields.io/codeclimate/coverage/Alexander-Senko/magic-decorator
)

A bit of history:
this gem was inspired by digging deeper into [Draper](https://github.com/drapergem/draper) with an eye on a refactoring.

It implements a general decorator logic. It’s not meant to be a _presenter_.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add magic-decorator

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install magic-decorator

## Usage

`Magic::Decorator::Base` is a basic decorator class to be inherited by any other decorator.
It further inherits from [`SimpleDelegator`](
	https://docs.ruby-lang.org/en/master/SimpleDelegator.html
) and is straightforward like that.

```ruby
class PersonDecorator < Magic::Decorator::Base
  def name = "#{first_name} #{last_name}"
end

Person = Struct.new :first_name, :last_name do
  include Magic::Decoratable
end

person = Person.new('John', 'Smith').decorate
person.name # => "John Smith"
```

### `Magic::Decoratable`

This module adds three methods to decorate an object.
Decorator class is being inferred automatically.
When no decorator is found,
- `#decorate`  returns `nil`,
- `#decorate!` raises `Magic::Lookup::Error`,
- `#decorated` returns the original object.

One can test for the object is actually decorated with `#decorated?`.

```ruby
'with no decorator for String'.decorated
    .decorated? # => false
['with a decorator for Array'].decorated
    .decorated? # => true
```

### Extending decorator logic

When extending `Magic::Decoratable`, one may override `#decorator_base` to be used for lookup.

```ruby
class Special::Decorator < Magic::Decorator::Base
  def self.name_for object_class
    "Special::#{object_class}Decorator"
  end
end

module Special::Decoratable
  include Magic::Decoratable

  private

  def decorator_base = Special::Decorator
end

class Special::Model
  include Special::Decoratable
end

Special::Model.new.decorate # looks for Special::Decorator descendants
```

## 🪄 Magic

### Decoratable scope

`Magic::Decoratable` is mixed into `Object` by default. It means that effectively any object is _magically decoratable_.

One can use `Magic::Decoratable.classes` to see all the decoratable classes.

### Decoration expansion

For almost any method called on a decorated object, both its result and `yield`ed arguments get decorated.

```ruby
'with no decorator for String'.decorated.chars
    .decorated? # => false
['with a decorator for Array'].decorated.map(&:chars).first.grep(/\S/).group_by(&:upcase).transform_values(&:size).sort_by(&:last).reverse.first(5).map(&:first)
    .decorated? # => true
```

#### Undecorated methods

Some methods aren’t meant to be decorated though:

- `deconstruct` & `deconstruct_keys` for _pattern matching_,
- _converting_ methods: those starting with `to_`,
- _system_ methods: those starting with `_`.

#### `undecorated` modifier

`Magic::Decorator::Base.undecorated` can be used to exclude methods from being decorated automagically.

```ruby
class MyDecorator < Magic::Decorator::Base
  undecorated %i[to_s inspect]
  undecorated :raw_method
  undecorated :m1, :m2
end
```

### Decorator class inference

Decorators provide automatic class inference for any object based on its class name
powered by [Magic Lookup](
	https://github.com/Alexander-Senko/magic-lookup
).

For example, `MyNamespace::MyModel.new.decorate` looks for `MyNamespace::MyModelDecorator` first.
When missing, it further looks for decorators for its ancestor classes, up to `ObjectDecorator`.

### Default decorators

#### `EnumerableDecorator`

It automagically decorates all its decoratable items.

```ruby
[1, [2], { 3 => 4 }, '5'].decorated
    .map &:decorated? # => [false, true, true, false]

{ 1 => 2, [3] => [4] }.decorated.keys
    .map &:decorated? # => [false, true]
{ 1 => 2, [3] => [4] }.decorated.values
    .map &:decorated? # => [false, true]

{ 1 => 2, [3] => [4] }.decorated[1]
    .decorated? # => false
{ 1 => 2, [3] => [4] }.decorated[[3]]
    .decorated? # => true
```

##### Side effects for decorated collections

- enables _splat_ operator: `*decorated` ,
- enables _double-splat_ operator: `**decorated`,
- enumerating methods yield decorated items.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Alexander-Senko/magic-decorator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Alexander-Senko/magic-decorator/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Magic Decorator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Alexander-Senko/magic-decorator/blob/main/CODE_OF_CONDUCT.md).
