require_relative 'card.rb'
class Hand
  include Comparable

  VALUES = %w[
    high_card
    one_pair
    two_pairs
    three_of_a_kind
    straight
    flush
    full_house
    four_of_a_kind
    straight_flush
    royal_flush
  ]

  attr_reader :cards
  attr_reader :hand_type
  def initialize(cards_strings, player_string)
    @cards = cards_strings.map { |card_str| Card.new(card_str) }.sort
    @hand_type = determine_hand(@cards, player_string)
  end

  def determine_hand(hand_cards, player_string)
    grouped_values = hand_cards.group_by { |card| card.value }
    grouped_suits = hand_cards.group_by { |card| card.suit }

    if duplicate_values_are_present?(grouped_values)
      puts "Duplicates were found in #{player_string} hand"
    elsif sequentially_increase_by_one?(hand_cards)
      puts "Straights were found in #{player_string} hand."
    elsif all_suits_match?(grouped_suits)
      puts "Flush was found in #{player_string} hand."
    else
      puts "High card was found in #{player_string} hand."
    end
  end

  def hand_rank
    VALUES.index(hand_type)
  end
  def hand_cards
    @cards.map { |card| card.to_s }.join(' ')
  end

  def duplicate_values_are_present?(grouped_values)
    grouped_values.any? {|key, values| values.size > 1}
  end

  def sequentially_increase_by_one?(array)
    array.each_cons(2).all? { |a, b| b.value_rank == a.value_rank + 1}
  end

  def all_suits_match?(grouped_suits)
    grouped_suits.one? {|key, values| values.size == 5 }
  end
end