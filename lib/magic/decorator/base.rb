# frozen_string_literal: true

require 'delegate'

module Magic
	module Decorator
		class Base < SimpleDelegator
			extend Lookup

			class << self
				def name_for(object_class) = "#{object_class}Decorator"
			end
		end
	end
end
