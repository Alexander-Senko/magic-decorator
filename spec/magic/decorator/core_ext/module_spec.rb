# frozen_string_literal: true

# Enhanced nested method chains
#
# rubocop:disable Layout/MultilineMethodCallIndentation

require 'magic/decorator/core_ext/module'
require 'active_support/core_ext/module/attribute_accessors'

RSpec.describe Module do
	subject { Class.new self.class }

	let(:object) { 2.times.map { rand } }

	describe '.decorated_method' do
		shared_context 'when decorates' do |*methods|
			if methods.any?
				metadata[:description] <<
						' ' << methods.map(&:inspect) * ', '

				it 'decorates method return values' do
					expect { subject[*methods] }.to change { methods.flatten.map { receiver.new.send(it).decorated? }.uniq }
							.from([ false ])
							.to [ true ]
				end if methods.flatten.any?

				it 'doesn’t enable future decoration' do
					subject[*methods]

					new_methods = 2.times.map do |i|
						receiver.define_method("method_#{i}") { object.try :__getobj__ }
					end

					expect(new_methods.map { receiver.new.send it })
							.not_to include be_decorated
				end
			else
				metadata[:description] =
						'with no arguments'

				it 'decorates subsequently defined methods' do
					subject[*methods]

					new_methods = 2.times.map do |i|
						receiver.define_method("method_#{i}") { object }
					end

					expect(new_methods.map { receiver.new.send it })
							.to all be_decorated
				end

				it 'doesn’t decorate previously defined methods' do
					subject[*methods]

					expect(object).not_to be_decorated
				end
			end

			its_result(*methods) { is_expected.to eq methods.then(unless: :many?, &:first) }
		end

		it_behaves_like 'when decorates', :object
		it_behaves_like 'when decorates', :object, :methods
		it_behaves_like 'when decorates', %i[ object methods ]
		it_behaves_like 'when decorates', %i[ object ]
		it_behaves_like 'when decorates', []
		it_behaves_like 'when decorates'

		its_result(:invalid) { is_expected.to eq :invalid }

		shared_context 'with visibility' do |visibility|
			metadata[:description]
					.sub! 'visibility', "#{visibility} visibility"

			send visibility, :object

			it 'preserves method visibility' do
				expect { subject[:object] }
						.not_to change { receiver.method_visibility :object }
								.from visibility
			end
		end

		it_behaves_like 'with visibility', :public
		it_behaves_like 'with visibility', :protected
		it_behaves_like 'with visibility', :private

		context 'with inheritance' do
			let(:child) { Class.new receiver }

			before { subject[:object] }

			it { expect(child.new.object).to be_decorated }
		end

		context 'with `method_added` callbacks defined' do
			cattr_reader(:added_methods) { [] }

			let(:new_method) { receiver.define_method(:new_method) { object } }

			def self.method_added name
				added_methods << name
			end

			before { subject.call }

			it 'preserves the callbacks' do
				expect { new_method }
						.to change { added_methods }
								.to %i[ new_method ]
			end
		end

		decorated_method def with_arguments argument, keyword:, &block
			[ argument, keyword, block.call ]
		end

		it 'preserves method’s arguments, keywords, and blocks' do
			expect(receiver.new.with_arguments(:positional, keyword: :keyword) { :block })
					.to eq %i[ positional keyword block ]
		end
	end
end
