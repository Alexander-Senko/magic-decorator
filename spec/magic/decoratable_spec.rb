# frozen_string_literal: true

module Magic
	RSpec.describe Decoratable do
		subject { object }

		let(:object) { 2.times.map { rand } }

		def decorator_class = Class.new Decorator::Base

		before do # HACK: decorators persist across examples somehow otherwise
			stub_const 'Magic::Decorator::Base', Class.new(Decorator::Base)
		end

		after { Decorator::Base.clear_memery_cache! }

		shared_context :decoratable do
			before { stub_const 'ArrayDecorator', decorator_class }
		end

		shared_examples 'returns decorated object' do
			its([]) { is_expected.to eq object }
			its([]) { is_expected.to be_decorated }
		end

		describe '#decorate', :method do
			it_behaves_like :decoratable do
				include_examples 'returns decorated object'
			end

			its([]) { is_expected.to be_nil }
		end

		describe '#decorate!', :method do
			it_behaves_like :decoratable do
				include_examples 'returns decorated object'
			end

			it { expect { subject[] }.to raise_error Lookup::Error }
		end

		describe '#decorated', :method do
			it_behaves_like :decoratable do
				include_examples 'returns decorated object'
			end

			its([]) { is_expected.to     eq object }
			its([]) { is_expected.not_to be_decorated }
		end

		describe '#decorated?', :method do
			let(:object) { super().decorated }

			it_behaves_like :decoratable do
				its([]) { is_expected.to be true }
			end

			its([]) { is_expected.to be false }
		end
	end
end
