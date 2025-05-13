# frozen_string_literal: true

require 'active_support/concern'

module Magic
	module Decoratable
		extend ActiveSupport::Concern

		class_methods do
			def classes
				ObjectSpace.each_object(Class)
						.select { _1 < self }
						.reject(&:singleton_class?)
			end
		end

		extend ClassMethods

		def decorate   = decorator&.new self
		def decorate!  = decorate || raise(Lookup::Error.for self, decorator_base)
		def decorated  = decorate || self
		def decorated? = false

		private

		def decorator      = decorator_base.for self.class
		def decorator_base = Decorator
	end
end
