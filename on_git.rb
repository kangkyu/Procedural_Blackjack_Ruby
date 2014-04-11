# terms and numbers
nums = { :ace => 11,
	:two => 2,
	:three => 3,
	:four => 4,
	:five => 5,
	:six => 6,
	:seven => 7,
	:eight => 8,
	:nine => 9,
	:ten => 10,
	:jack => 10,
	:queen => 10,
	:king => 10 }
suits = ['spade', 'heart', 'diamond', 'club']
# a set of cards for example = [[{:seven=>7}, "spade"], [{:ja=>10}, "club"], [{:qu=>10}, "spade"], [{:qu=>10}, "heart"], [{:ace=>11}, "spade"], [{:nine=>9}, "diamond"], [{:seven=>7}, "club"], [{:six=>6}, "club"], [{:three=>3}, "heart"], [{:six=>6}, "diamond"], [{:five=>5}, "diamond"], [{:four=>4}, "club"], [{:ka=>10}, "diamond"], [{:four=>4}, "spade"], [{:nine=>9}, "heart"], [{:eight=>8}, "spade"], [{:six=>6}, "heart"], [{:eight=>8}, "heart"], [{:nine=>9}, "club"], [{:ja=>10}, "spade"], [{:three=>3}, "spade"], [{:three=>3}, "diamond"], [{:ka=>10}, "spade"], [{:ten=>10}, "club"], [{:ace=>11}, "club"], [{:ka=>10}, "heart"], [{:ka=>10}, "club"], [{:three=>3}, "club"], [{:two=>2}, "club"], [{:five=>5}, "heart"], [{:ja=>10}, "heart"], [{:ten=>10}, "heart"], [{:eight=>8}, "diamond"], [{:eight=>8}, "club"], [{:four=>4}, "heart"], [{:ja=>10}, "diamond"], [{:five=>5}, "club"], [{:two=>2}, "diamond"], [{:qu=>10}, "club"], [{:ace=>11}, "heart"], [{:ten=>10}, "spade"], [{:two=>2}, "spade"], [{:six=>6}, "spade"], [{:ace=>11}, "diamond"], [{:nine=>9}, "spade"], [{:five=>5}, "spade"], [{:two=>2}, "heart"], [{:qu=>10}, "diamond"], [{:seven=>7}, "heart"], [{:four=>4}, "diamond"], [{:ten=>10}, "diamond"], [{:seven=>7}, "diamond"]]
deck = []
puts "Hello, before we start the game,"
puts "may I have your first name?"
me_name = gets.chomp.capitalize
puts "Pleased to meet you, #{me_name}."
def ask_num question
	puts question
	say = gets.chomp.to_i
	if (say >= 2 && say <= 4)
			say
	else
			ask_num "Supposed to say a number between 2 to 4.. how many?"
	end
end
num_deck = ask_num "We use multiple decks, please choose 2 to 4."
puts "We use #{num_deck} card sets. Let's start in a moment..."
# multi-deck cards are ready
(1..num_deck).each do
	suits.each do |suit|
		nums.each do |key, value|
			deck.push [{key => value}, suit]
		end
	end
end
me_sum = dealer_sum = 0
puts '=========================='
puts 'deck size'.ljust(12) + (' = ' + deck.size.to_s).rjust(3)
puts 'my number'.ljust(12) + (' = ' + me_sum.to_s).rjust(3)
puts 'dealer\'s'.ljust(12) + (' = ' + dealer_sum.to_s).rjust(3)
puts '=========================='
# shuffle and start
puts 
deck = deck.sort_by{rand} 
# method: deal_a_card
def deal_a_card curr_deck
	card = curr_deck.pop
	[card, curr_deck]
end
# deal two cards for each person
2.times do
	after_deal = deal_a_card deck
	puts "#{me_name}, you've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
	me_sum = me_sum + after_deal[0][0].values.join.to_i
end
puts "now for you it's #{me_sum}."
2.times do
	after_deal = deal_a_card deck 
	puts "I've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
	dealer_sum = dealer_sum + after_deal[0][0].values.join.to_i
end
puts "now for me it's #{dealer_sum}."
puts '=========================='
puts 'deck size'.ljust(12) + (' = ' + deck.size.to_s).rjust(3)
puts 'my number'.ljust(12) + (' = ' + me_sum.to_s).rjust(3)
puts 'dealer\'s'.ljust(12) + (' = ' + dealer_sum.to_s).rjust(3)
puts '=========================='
# method: ask player to decide if hit
def ask_hit question
	puts question
	say = gets.chomp.downcase
	if (say == 'hit' || say == 'stay')
			say
	else
			ask_hit "#{me_name}, you are supposed to say 'hit' or 'stay'"
	end
end
# rally starts
the_rally = true
busted = false
me_closed = dealer_closed = false
while the_rally
	# my turn - dealer asks, I decide if hit
	# one more card in my hand if I type 'hit'
	unless me_closed
		decision = ask_hit 'Your turn!'
		puts "Okay you said '#{decision}'"
		if decision == 'hit'
			after_deal = deal_a_card deck 
			puts "You've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
			me_sum = me_sum + after_deal[0][0].values.join.to_i
			puts "now for you it's #{me_sum}."
		else
			puts "Your final number is #{me_sum}."
			me_closed = true
		end
		# game is over if anyone 'busted' (greater than 21) 
		# if one busted, the other one wins
		if me_sum > 21
			puts "and you're busted. I won."
			break
		end
	end
	# dealer's turn - 'By rule, the dealer must hit 
	# until she has at least 17'
	unless dealer_closed
		puts 'My turn!'
		decision = if	dealer_sum < 17 
			'hit'
		else
			'stay'
		end
		if decision == 'hit'
			puts "I say 'hit'"
			after_deal = deal_a_card deck 
			puts "I've got #{after_deal[0][0].keys.join} of #{after_deal[0][1]}s"
			dealer_sum = dealer_sum + after_deal[0][0].values.join.to_i
			puts "now for me it's #{dealer_sum}."
		else
			puts "I say 'stay', my final number is #{dealer_sum}"
			dealer_closed = true
		end
		# game is over if anyone 'busted' (greater than 21) 
		# if one busted, the other one wins
		if dealer_sum > 21
			puts "and I'm busted. You won."
			break
		end
	end
	# game is over if both stay (both equal or less than 21) and,
	# in that case, compare number = same('push?') or more number wins
	if (dealer_closed == true && me_closed == true)
		if dealer_sum == me_sum
			puts "We draw. another game?"
		elsif dealer_sum > me_sum
			puts "Your final number is lower, I won."
			puts "And I am BLACKJACK!" if dealer_sum == 21
		else
			puts "Your final number is higher, You won."
			puts "And #{me_name}, you're BLACKJACK!" if me_sum == 21
		end
		break
	end
	puts '=========================='
	puts 'deck size'.ljust(12) + (' = ' + deck.size.to_s).rjust(3)
	puts 'my number'.ljust(12) + (' = ' + me_sum.to_s).rjust(3)
	puts 'dealer\'s'.ljust(12) + (' = ' + dealer_sum.to_s).rjust(3)
	puts '=========================='
end

# more to do..
# Ace value 2 different interpretation
# calculate-total method
# ask if the player wants to play again, after a game
