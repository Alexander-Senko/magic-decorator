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
			rescue NoMethodError => error
				__raise__ error.class.new(
						error.message.sub(self.class.name, __getobj__.class.name),
						error.name,
						error.args,
				#		error.private_call?, # FIXME: not implemented in TruffleRuby

						receiver: __getobj__
				).tap {
					_1.set_backtrace error.backtrace[2..] # FIXME: use `backtrace_locations` with Ruby 3.4+
				}
			end
		end
	end
end
