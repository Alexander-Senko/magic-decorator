# frozen_string_literal: true

require 'delegate'

module Magic
	module Decorator
		class Base < SimpleDelegator
			extend Lookup

			class << self
				def name_for(object_class) = "#{object_class}Decorator"
			end

			def decorated? = true

			def method_missing(...)
				if block_given?
					super { |*args| yield *args.map(&:decorated) }
				else
					super
				end.decorated
			end
		end
	end
end
