# frozen_string_literal: true

RSpec.describe EnumerableDecorator do
	subject { array.decorate! }

	let(:array) { [ 1, [ 2 ], { 3 => 4 }, '5' ] }
	let(:hash)  { { x: 1, y: 2, [ 3 ] => [ 4 ] } }

	describe 'converting' do
		describe 'to Array' do
			describe '#to_a' do
				its_result { is_expected.not_to be_decorated }
				its_result { is_expected.to include be_decorated }

				it 'enables splat operator for decorated objects' do
					expect([ *array.decorated ][1]).to be_decorated
				end
			end

			describe '#to_ary' do
				its_result { is_expected.not_to be_decorated }
				its_result { is_expected.to include be_decorated }

				it 'decorates every yielded argument' do
					{ [1] => [2] }.decorated
							.each do |key, value|
								expect(key  ).to be_decorated
								expect(value).to be_decorated
							end
				end
			end
		end

		describe 'to Hash' do
			describe '#to_h' do
				subject { hash.to_a.decorate! }

				its_result { is_expected.not_to be_decorated }
				its_result { is_expected.to have_attributes keys:   (include be_decorated) }
				its_result { is_expected.to have_attributes values: (include be_decorated) }
			end

			describe '#to_hash' do
				subject { hash.decorate! }

				its_result { is_expected.not_to be_decorated }
				its_result { is_expected.to have_attributes keys:   (include be_decorated) }
				its_result { is_expected.to have_attributes values: (include be_decorated) }

				it 'enables double-splat operator for decorated objects' do
					expect({ **hash.decorated }[[ 3 ].decorate]).to be_decorated
				end
			end
		end
	end
end
