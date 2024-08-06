require_relative 'card.rb'
class Hand
  include Comparable

  attr_reader :cards
  def initialize(cards_strings)
    @cards = cards_strings.map { |card_str| Card.new(card_str) }.sort
  end
end