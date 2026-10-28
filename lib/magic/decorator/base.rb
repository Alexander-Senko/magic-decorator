# frozen_string_literal: true

require 'delegate'

module Magic
	module Decorator
		# = Magic Decorator
		#
		# Any decorator should inherit `Magic::Decorator::Base`.
		# It further inherits from `SimpleDelegator` and behaves like that.
		#
		# == Decorator class inference
		#
		# Decorators provide automatic class inference for any class based
		# on its name powered by Magic Lookup.
		# For example, `MyObject.new` looks for `MyObjectDecorator` first.
		# If not found, it looks for decorators of its ancestor classes,
		# up to `ObjectDecorator`.
		class Base < SimpleDelegator
			extend  Lookup
			include Decoratable

			class << self
				def name_for(object_class) = "#{object_class}Decorator"

				def to_s = super
						.delete_suffix('::Base')

				private

				def undecorated method, *methods
					return [ method, *methods ].map { undecorated it } if
							methods.any?
					return undecorated *method if
							method.is_a? Array
					raise TypeError, "#{method} is not a symbol, nor a string" unless
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

			private

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
					it.set_backtrace error.backtrace_locations[2...]
				}
			end
		end
	end
end
