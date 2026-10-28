# frozen_string_literal: true

require 'magic/lookup'

require_relative 'decorator/version'

module Magic # :nodoc:
	autoload :Decoratable, 'magic/decoratable'

	Object.include Decoratable

	# = Magic Decorator
	#
	# It implements a general decorator logic. It is not meant to be a
	# presenter.
	module Decorator
		autoload :Base, 'magic/decorator/base'

		module_function

		def for(...)      = Base.for(...)
		def name_for(...) = Base.name_for(...)
	end
end

require 'enumerable_decorator'
