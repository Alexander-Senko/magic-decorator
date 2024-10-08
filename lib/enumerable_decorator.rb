# frozen_string_literal: true

class EnumerableDecorator < Magic::Decorator::Base
	def to_a(...)   = super.map &:decorated
	def to_ary(...) = super.map &:decorated

	def to_h(...)    = super.to_h { |*h| h.map! &:decorated }
	def to_hash(...) = super.to_h { |*h| h.map! &:decorated }
end
