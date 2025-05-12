# frozen_string_literal: true

module Magic
	RSpec.describe Decorator do
		describe '.for' do
			it_behaves_like :delegated,
					to: Decorator::Base, with: Class.new
		end

		describe '.name_for' do
			it_behaves_like :delegated,
					to: Decorator::Base, with: Class.new
		end
	end
end
