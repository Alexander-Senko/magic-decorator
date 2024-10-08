# frozen_string_literal: true

module Magic
	module Decoratable
		def decorate   = decorator&.new self
		def decorate!  = decorate || raise(Lookup::Error.for self, Decorator)
		def decorated  = decorate || self
		def decorated? = false

		private

		def decorator = Decorator.for self.class
	end
end
