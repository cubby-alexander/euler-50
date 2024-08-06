require_relative 'lib/poker'

puts "Evaluating poker hands in poker.txt..."

hand_file_path = 'poker.txt'

poker_evaluation = Poker.new(hand_file_path)
player1_total_wins = poker_evaluation.play

puts "Player 1 won a total of #{player1_total_wins} hands."