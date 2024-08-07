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
      player1_hand = Hand.new(cards[0, 5], 'Player 1')
      player2_hand = Hand.new(cards[5, 5], 'Player 2')

      puts "Player 1 hand: #{player1_hand.hand_cards}, #{player1_hand.hand_details[:type]}, ranked #{player1_hand.hand_rank}; Player 2 hand: #{player2_hand.hand_cards} #{player2_hand.hand_details[:type]}, ranked #{player2_hand.hand_rank}"
      if player1_hand.hand_rank > player2_hand.hand_rank
        player1_wins += 1
      elsif player1_hand.hand_rank == player2_hand.hand_rank
        if player1_hand.hand_details[:high_card].value_rank > player2_hand.hand_details[:high_card].value_rank
          player1_wins += 1
        end
      end
    puts player1_wins
    end


    player1_wins
  end
end