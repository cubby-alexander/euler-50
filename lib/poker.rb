require_relative 'card'
require_relative 'hand'

class Poker
  def initialize(file_path)
    @file_path = file_path
  end

  def play
    player1_wins = 0

    File.foreach(@file_path) do |line|
      cards = line.split
      player1_hand = Hand.new(cards[0, 5])
      player2_hand = Hand.new(cards[5, 5])

      puts "Player 1 hand: #{player1_hand.cards}, Player 2 hand: #{player2_hand.cards}"
      player1_wins += 1
    end

    player1_wins
  end
end