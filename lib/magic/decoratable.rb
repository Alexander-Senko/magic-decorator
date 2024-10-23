# frozen_string_literal: true

module Magic
	module Decoratable
		def decorate   = decorator&.new self
		def decorate!  = decorate || raise(Lookup::Error.for self, decorator_base)
		def decorated  = decorate || self
		def decorated? = false

		private

		def decorator      = decorator_base.for self.class
		def decorator_base = Decorator
	end
end
