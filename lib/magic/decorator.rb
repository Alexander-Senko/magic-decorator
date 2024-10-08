# frozen_string_literal: true

require 'magic/lookup'

require_relative 'decorator/version'

module Magic
	autoload :Decoratable, 'magic/decoratable'

	Object.include Decoratable

	module Decorator
		autoload :Base, 'magic/decorator/base'

		module_function

		def for(...)      = Base.for(...)
		def name_for(...) = Base.name_for(...)
	end
end
