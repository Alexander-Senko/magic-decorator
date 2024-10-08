# frozen_string_literal: true

module Magic
	module Decorator
		RSpec.describe Base do
			subject { decorated }

			let(:object) { random_array }
			let(:decorated) { object.decorate! }

			def random_array = 2.times.map { rand }

			describe 'method decoration' do
				shared_context '#random_method' do
					include_context :method

					let(:arguments) { random_array }
					let(:result) { random_array }
					let(:yields) { 2.times.map { random_array } }

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
								expect(args).to all be_decorated
							end
						end
					end
				end

				describe '#missing_method', :method do
					let(:arguments) { random_array }

					it 'masquerades exceptions' do
						expect { subject.call *arguments }.to raise_error(NoMethodError) { |error|
							expect(error).to have_attributes(
									message: /undefined method ['`]#{method_name}' for .*Array/, # FIXME: use Ruby 3.4+ version
									receiver: object,
									name:     method_name,
									args:     arguments,
							)
						}
					end
				end

				describe '.undecorated', :method do
					it_behaves_like '#random_method' do
						before { decorated.class.send :undecorated, method_name }

						its([]) { is_expected.not_to be_decorated }

						it_behaves_like 'with a block' do
							it 'does not decorate yielded arguments' do
								subject.call do |*args|
									expect(args).not_to include be_decorated
								end
							end
						end
					end

					describe 'arguments' do
						Object.class_eval do
							def in?(collection) = collection.include? self
						end

						its([ :m1 ]) { is_expected.to eq :m1 }
						its([ 'm2' ]) { is_expected.to eq :m2 }
						its([ :m1, 'm2' ]) { is_expected.to eq %i[m1 m2] }
						its([ [ :m1, 'm2' ] ]) { is_expected.to eq %i[m1 m2] }

						it { expect { subject[:m1, 2] }.to raise_error TypeError }

						its([ :m1 ]) { is_expected.to be_in subject.receiver.instance_methods(false) }
						its([ 'm2' ]) { is_expected.to be_in subject.receiver.instance_methods(false) }
						its([ :m1, 'm2' ]) { is_expected.to be_intersect subject.receiver.instance_methods(false) }
						its([ [ :m1, 'm2' ] ]) { is_expected.to be_intersect subject.receiver.instance_methods(false) }
					end

					describe 'by default' do
						describe '#deconstruct' do
							it { expect { decorated => x, y }.not_to raise_error }
						end

						describe '#deconstruct_keys' do
							it { expect { { x: rand }.decorated => x: }.not_to raise_error }
						end
					end
				end
			end
		end
	end
end
