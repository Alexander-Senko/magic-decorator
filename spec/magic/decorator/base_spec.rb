# frozen_string_literal: true

module Magic
	module Decorator
		RSpec.describe Base do
			subject { decorated }

			let(:object)    { random_array }
			let(:decorated) { object.decorate! }

			def random_array = 2.times.map { rand }

			before { stub_const 'ArrayDecorator', described_class }
			after  { Decorator::Base.clear_memery_cache! }

			describe 'method decoration' do
				shared_context '#random_method' do
					include_context :method

					let(:arguments) { random_array }
					let(:result)    { random_array }
					let(:yields)    { 2.times.map { random_array } }

					before { allow(object).to receive(method_name).and_return result }

					shared_context('with a block') {
						before { allow(object).to receive(method_name).and_yield *yields }
					}

					it 'forwards arguments' do
						subject[*arguments]

						expect(object).to have_received(method_name).with *arguments
					end

					it_behaves_like 'with a block' do
						it 'forwards yielded arguments' do
							subject.call do |*args|
								expect(args).to eq yields
							end
						end
					end
				end

				it_behaves_like '#random_method' do
					its([]) { is_expected.to be_decorated }

					it_behaves_like 'with a block' do
						it 'decorates yielded arguments' do
							subject.call do |*args|
								expect(args).to be_all &:decorated?
							end
						end
					end
				end
			end
		end
	end
end