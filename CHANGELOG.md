## [0.2.0] — UNRELEASED

### Changed

- For almost any method called on a decorated object, both its result and `yield`ed arguments get decorated.
  Some methods aren’t meant to be decorated though:
	- `deconstruct` & `deconstruct_keys` for _pattern matching_,
	- _converting_ methods: those starting with `to_`,
	- _system_ methods: those starting with `_`.

### Added

- `Magic::Decorator::Base.undecorated` to exclude methods from being decorated automagically.

#### Default decorators

- `EnumerableDecorator` to decorate `Enumerable`s.
	- enables _splat_ operator: `*decorated` ,
	- enables _double-splat_ operator: `**decorated`,
	- enumerating methods yield decorated items.

## [0.1.0] — 2024-10-13

### Added

- `Magic::Decorator::Base` — a basic decorator class.
- `Magic::Decoratable` to be included in decoratable classes.
	- `#decorate`,
	- `#decorate!`,
	- `#decorated`,
	- `#decorated?`.
