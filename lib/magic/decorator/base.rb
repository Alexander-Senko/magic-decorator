# frozen_string_literal: true

require 'delegate'

module Magic
	module Decorator
		class Base < SimpleDelegator
			extend Lookup

			class << self
				def name_for(object_class) = "#{object_class}Decorator"

				private

				def undecorated method, *methods
					return [ method, *methods ].map { undecorated _1 } if
							methods.any?
					return undecorated *method if
							method.is_a? Array
					raise TypeError, "#{method} is not a symbol nor a string" unless
							method in Symbol | String

					class_eval <<~RUBY, __FILE__, __LINE__ + 1
						def #{method}(...) = __getobj__.#{method}(...)
					RUBY
				end
			end

			def decorated? = true

			undecorated %i[
					deconstruct
					deconstruct_keys
			]

			def method_missing(method, ...)
				return super if method.start_with? 'to_' # converter
				return super if method.start_with? '_'   # system

				if block_given?
					super { |*args| yield *args.map(&:decorated) }
				else
					super
				end.decorated
			end
		end
	end
end
