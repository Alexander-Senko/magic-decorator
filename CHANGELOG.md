## [0.2.0] — UNRELEASED

### Changed

- For any method called on a decorated object, both its result and `yield`ed arguments get decorated.


## [0.1.0] — 2024-10-13

### Added

- `Magic::Decorator::Base` — a basic decorator class.
- `Magic::Decoratable` to be included in decoratable classes.
	- `#decorate`,
	- `#decorate!`,
	- `#decorated`,
	- `#decorated?`.
