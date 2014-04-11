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
	:ja => 10,
	:qu => 10,
	:ka => 10 }
suits = ['spade', 'heart', 'diamond', 'club']
# a deck ready, for example = [[{:seven=>7}, "spade"], [{:ja=>10}, "club"], [{:qu=>10}, "spade"], [{:qu=>10}, "heart"], [{:ace=>11}, "spade"], [{:nine=>9}, "diamond"], [{:seven=>7}, "club"], [{:six=>6}, "club"], [{:three=>3}, "heart"], [{:six=>6}, "diamond"], [{:five=>5}, "diamond"], [{:four=>4}, "club"], [{:ka=>10}, "diamond"], [{:four=>4}, "spade"], [{:nine=>9}, "heart"], [{:eight=>8}, "spade"], [{:six=>6}, "heart"], [{:eight=>8}, "heart"], [{:nine=>9}, "club"], [{:ja=>10}, "spade"], [{:three=>3}, "spade"], [{:three=>3}, "diamond"], [{:ka=>10}, "spade"], [{:ten=>10}, "club"], [{:ace=>11}, "club"], [{:ka=>10}, "heart"], [{:ka=>10}, "club"], [{:three=>3}, "club"], [{:two=>2}, "club"], [{:five=>5}, "heart"], [{:ja=>10}, "heart"], [{:ten=>10}, "heart"], [{:eight=>8}, "diamond"], [{:eight=>8}, "club"], [{:four=>4}, "heart"], [{:ja=>10}, "diamond"], [{:five=>5}, "club"], [{:two=>2}, "diamond"], [{:qu=>10}, "club"], [{:ace=>11}, "heart"], [{:ten=>10}, "spade"], [{:two=>2}, "spade"], [{:six=>6}, "spade"], [{:ace=>11}, "diamond"], [{:nine=>9}, "spade"], [{:five=>5}, "spade"], [{:two=>2}, "heart"], [{:qu=>10}, "diamond"], [{:seven=>7}, "heart"], [{:four=>4}, "diamond"], [{:ten=>10}, "diamond"], [{:seven=>7}, "diamond"]]
deck = []
suits.each do |suit|
	nums.each do |key, value|
		deck.push [{key => value}, suit]
	end
end
deck = deck.sort_by{rand} 
# method: ask player to decide
def ask question
	puts question
	say = gets.chomp.downcase
	if (say == 'hit' || say == 'stay')
			say
	else
			puts "You are supposed to say 'hit' or 'stay'"
			ask question
	end
end
# method: deal_with_hit - give a card when 'hit'
def deal_with_hit before_deck
	curr_deck = before_deck
	card = curr_deck.pop
	[card, curr_deck]
end
# shuffle and start
deck = deck.sort_by{rand} 
me_sum = dealer_sum = 0
me_closed = dealer_closed = false
the_rally = true
busted = false
while the_rally
	# my turn - dealer asks and I decide
	# one more card in my hand if I type 'hit'
	unless me_closed
		decision = ask 'Your turn!'
		puts "Okay you said '#{decision}'"
		if decision == 'hit'
			after_hit = deal_with_hit deck 
			puts "You've got #{after_hit[0][0].keys.join} of #{after_hit[0][1]}s"
			me_sum = me_sum + after_hit[0][0].values.join.to_i
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
			after_hit = deal_with_hit deck 
			puts "I've got #{after_hit[0][0].keys.join} of #{after_hit[0][1]}s"
			dealer_sum = dealer_sum + after_hit[0][0].values.join.to_i
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
			puts "we draw. another game?"
		elsif dealer_sum > me_sum
			puts "your final number is lower, I won."
			puts "And I am BLACKJACK!" if dealer_sum == 21
		else
			puts "your final number is higher, You won."
			puts "And you're BLACKJACK!" if me_sum == 21
		end
		break
	end
	puts '=========================='
	puts 'deck size'.ljust(12) + (' = ' + deck.size.to_s).rjust(3)
	puts 'my number'.ljust(12) + (' = ' + me_sum.to_s).rjust(3)
	puts 'dealer\'s'.ljust(12) + (' = ' + dealer_sum.to_s).rjust(3)
	puts '=========================='
end
