# deck on
deck = ['h','c','s','d'].product ['2','3','4','5','6','7','8','9','10','A','Q','K','J']
deck.shuffle!

# first deal of the round
dealer_hand = []
player_hand = []
dealer_hand << deck.pop << deck.pop
player_hand << deck.pop << deck.pop

# announce the cards and points
def word_for(char)
  case char
  when 'h' then 'hearts'
  when 'c' then 'clubs'
  when 's' then 'spades'
  when 'd' then 'diamonds'
  when 'A' then 'ace'
  when 'Q' then 'queen'
  when 'J' then 'jack'
  when 'K' then 'king'
  when '2' then 'two'
  when '3' then 'three'
  when '4' then 'four'
  when '5' then 'five'
  when '6' then 'six'
  when '7' then 'seven'
  when '8' then 'eight'
  when '9' then 'nine'
  when '10' then 'ten'
  end
end

def card_name(card) # ['h','2'] #=> 'Two of Hearts'
  "#{word_for(card.last).capitalize} of #{word_for(card.first).capitalize}"
end
 
def points_hand(hand) # [['h','2'], ['c','3']] #=> 5
  ranks = hand.map { |e| e[1] } 
  points = 0
  ace_appears = 0
  ranks.each do |rank|
    if rank == 'A'
      points += 11
      ace_appears += 1
    elsif rank.to_i == 0
      points += 10
    else
      points += rank.to_i 
    end
  end
  ace_appears.times do
    if points > 21
      points -= 10
    end
  end
  points
end

puts "dealer has:"
puts " => #(hidden)"
puts " => " + card_name(dealer_hand.last)
puts "? + #{points_hand([dealer_hand.last])}"

puts "player has:"
player_hand.each do |card|
  puts " => " + card_name(card)
end

# check if player BlackJack
if points_hand(player_hand) == 21
  puts "player BlackJack"
  exit
end

puts "#{points_hand(player_hand)}"

# player's turn (Hit or Stay)
puts "player turn"
while true
  puts "1) hit or 2) stay?"
  gets.chomp == '1' ? hit = true : hit = false
  if hit
    player_hand << deck.pop

    puts "player has:"
    player_hand.each do |card|
      puts " => " + card_name(card)
    end
    puts "#{points_hand(player_hand)}"

    if points_hand(player_hand) > 21
      puts "player busts"
      exit
    elsif points_hand(player_hand) == 21
      break
    end
  else
    break
  end
end
puts "player stays at #{points_hand(player_hand)}"

# dealer turn - hit under 17, stay over 17.
puts "dealer_turn"
puts "dealer's first two cards are"
dealer_hand.each do |card|
  puts " => " + card_name(card)
end

if points_hand(dealer_hand) == 21
  puts "dealer BlackJack"
  exit
end

puts "#{points_hand(dealer_hand)}"

while true

  if points_hand(dealer_hand) < 17
    puts "dealer hits"
    dealer_hand << deck.pop

    puts "dealer has:"
    dealer_hand.each do |card|
      puts " => " + card_name(card)
    end
    puts "#{points_hand(dealer_hand)}"
    
    if points_hand(dealer_hand) > 21
      puts "dealer busts"
      exit
    elsif points_hand(dealer_hand) == 21
      break
    end

  else
    puts "dealer stays"
    break
  end
end

# compare
player_this_much_more = points_hand(player_hand) - points_hand(dealer_hand)
if player_this_much_more == 0
  puts "it's push. nobody won"
elsif player_this_much_more > 0
  puts "player won."
else # player_this_much_more < 0
  puts "dealer won."
end

exit