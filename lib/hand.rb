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
  attr_reader :hand_details

  def initialize(cards_strings, player_string)
    @cards = cards_strings.map { |card_str| Card.new(card_str) }.sort
    @hand_details = determine_hand_details(@cards, player_string)
  end

  def determine_hand_details(hand_cards, player_string)
    grouped_card_values = hand_cards.group_by { |card| card.value }
    grouped_card_suits = hand_cards.group_by { |card| card.suit }

    if duplicate_values_are_present?(grouped_card_values)
      # Checking if hand has more than one pair
      duplicate_groups = grouped_card_values.values.select { |group| group.size > 1 }
      if duplicate_groups.size > 1
        assay_multiple_duplicates(grouped_card_values)
      else
        assay_single_duplicate(grouped_card_values)
      end
    elsif sequentially_increase_by_one?(hand_cards)
      assay_sequential_set(hand_cards)
    elsif all_suits_match?(grouped_card_suits)
      {
        type: 'flush',
        high_card: hand_cards[4],         #High card (hand sorted asc. in initialize)
        second_high_card: hand_cards[3],  #Second high card
        third_high_card: hand_cards[2],   #Third high card
      }
    else
      {
        type: 'high_card',
        high_card: hand_cards[4],         #High card (hand sorted asc. in initialize)
        second_high_card: hand_cards[3],  #Second high card
        third_high_card: hand_cards[2],   #Third high card
      }
    end
  end

  def hand_rank
    VALUES.index(hand_details[:type])
  end

  def hand_cards
    @cards.map { |card| card.to_s }.join(' ')
  end

  def duplicate_values_are_present?(grouped_card_values)
    grouped_card_values.any? { |key, values| values.size > 1 }
  end

  def assay_multiple_duplicates(grouped_card_values)
    sorted_groups = grouped_card_values.values.sort_by { |group| [-group.size, -group[0].value_rank] }
    if sorted_groups.size >= 3 && sorted_groups[0].size == 2 && sorted_groups[1].size == 2
      {
        type: "two_pairs",
        high_card: sorted_groups[0][0],         # Highest pair
        second_high_card: sorted_groups[1][0],  # Second highest pair
        third_high_card: sorted_groups[2][0],   # Kicker
      }
    elsif sorted_groups.size == 2 && sorted_groups[0].size == 3 && sorted_groups[1].size == 2
      {
        type: "full_house",
        high_card: sorted_groups[0][0],         # Three of a kind
        second_high_card: sorted_groups[1][0],  # Pair
        third_high_card: nil,
      }
    end
  end

  def assay_single_duplicate(grouped_card_values)
    sorted_groups = grouped_card_values.values.sort_by { |group| [-group.size] }
    if sorted_groups.size == 4
      {
        type: "one_pair",
        high_card: sorted_groups[0][0],         # Pair card value
        second_high_card: sorted_groups[1][0],  # First non-pair high card
        third_high_card: sorted_groups[2][0],   # Second non-pair high card
      }
    elsif sorted_groups.size == 3
      {
        type: "three_of_a_kind",
        high_card: sorted_groups[0][0],         # ToaK card value
        second_high_card: sorted_groups[1][0],  # First non-ToaK high card
        third_high_card: sorted_groups[2][0],   # Second non-ToaK high card
      }
    else
      {
        type: "four_of_a_kind",
        high_card: sorted_groups[0][0],         # FoaK card value
        second_high_card: sorted_groups[1][0],  # First non-FoaK high card
        third_high_card: nil,                         # Second non-FoaK high card
      }
    end
  end

  def assay_sequential_set(hand_cards)
    cards_grouped_by_suit = hand_cards.group_by { |card| card.suit }
    if cards_grouped_by_suit.size === 1
      if hand_cards[4].value == 'A'
        {
          type: "royal_flush",
          high_card: hand_cards[4],
          second_high_card: hand_cards[3],
          third_high_card: hand_cards[2],
        }
      else
      {
        type: "straight_flush",
        high_card: hand_cards[4],
        second_high_card: hand_cards[3],
        third_high_card: hand_cards[2],
      }
      end
    else
      {
        type: "straight",
        high_card: hand_cards[4],
        second_high_card: hand_cards[3],
        third_high_card: hand_cards[2],
      }
    end
  end

  def sequentially_increase_by_one?(array)
    array.each_cons(2).all? { |a, b| b.value_rank == a.value_rank + 1 }
  end

  def all_suits_match?(grouped_card_suits)
    grouped_card_suits.one? { |key, values| values.size == 5 }
  end
end