## [1.0.0] — 2024-11-23

This release marks the gem to be stable enough.

> [!NOTE]
> Nothing notable was changed in the code since the last version.

### Documentation

- Added a section about overriding the defaults.
- Added a section about testing.


## [0.3.0] — 2024-10-27

### Added

- Improved extendability: one may override `Magic::Decoratable#decorator_base` to be used for lookups.
- `Magic::Decoratable.classes` for all the decoratables.

### Fixed

- Failures on double decoration attempts.


## [0.2.0] — 2024-10-17

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
