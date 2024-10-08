# frozen_string_literal: true

module Magic
	RSpec.describe Decorator do
		describe '.for', :method do
			it_behaves_like :delegated,
					to: Decorator::Base, with: Array
		end

		describe '.name_for', :method do
			it_behaves_like :delegated,
					to: Decorator::Base, with: Array
		end
	end
end
