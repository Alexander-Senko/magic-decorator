# frozen_string_literal: true

# rubocop:disable Lint/EmptyInPattern

require 'active_support/core_ext/module/redefine_method'

# Extends Module with method return-value decoration.
class Module
	# Prepend it to decorate all subsequently defined instance methods.
	module DecorateAllMethods
		def method_added name
			super

			decorated_method name
		end
	end

	# Decorates the return values of named instance methods.
	#
	# Like Module#private, names can be passed individually or as a single array.
	# With no arguments, subsequently defined instance methods are decorated.
	def decorated_method *methods
		case methods
		in []
			singleton_class.prepend DecorateAllMethods

			return
		in [ Symbol | String => method ]
		in [ (Symbol | String), * ]
		in [ [ (Symbol | String), * ] | [] => methods ]
		end

		location = caller_locations(1, 1).first

		methods.map do |method|
			decorated_methods_module.module_eval <<~RUBY.strip, location.path, location.lineno
				#{method_visibility method} def #{method}(...) = super.decorated
			RUBY
		end

		method || methods
	end

	private

	def decorated_methods_module
		if const_defined? :DecoratedMethods, false
			const_get :DecoratedMethods
		else
			const_set :DecoratedMethods, Module.new
					.tap { it.include const_get :DecoratedMethods if const_defined? :DecoratedMethods } # inheritance
					.tap { prepend it }
		end
	end
end
